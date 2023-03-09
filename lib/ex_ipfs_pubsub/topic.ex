defmodule ExIpfsPubsub.Topic do
  @moduledoc false

  use GenServer, restart: :transient

  require Logger
  alias ExIpfs.ApiStreamingClient
  alias ExIpfs.Multibase
  alias ExIpfsPubsub.Message

  @api_url Application.compile_env(:ex_ipfs, :api_url, "http://127.0.0.1:5001/api/v0")
  @registry ExIpfsPubsub.Registry

  @enforce_keys [:base64url_topic, :handler, :subscribers, :topic]
  defstruct base64url_topic: nil, handler: nil, subscribers: MapSet.new(), topic: nil

  @type t :: %__MODULE__{
          base64url_topic: binary | nil,
          handler: pid | nil,
          subscribers: MapSet.t(pid),
          topic: binary
        }

  @spec new!(binary, pid) :: t()
  def new!(topic, subscriber) when is_pid(subscriber) do
    %__MODULE__{
      base64url_topic: Multibase.encode!(topic, b: "base64url"),
      handler: nil,
      subscribers: MapSet.new([subscriber]),
      topic: topic
    }
  end

  @spec start_link(t) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(topic) when is_struct(topic) do
    Logger.debug("Starting topic handler for #{topic.topic}")

    name = via_tuple(topic.topic)

    GenServer.start_link(
      __MODULE__,
      topic,
      name: name
    )
  end

  @spec init(t()) :: {:ok, t()}
  def init(topic) when is_struct(topic) do
    Logger.debug("Initializing topic handler for #{topic.topic}")
    state = %__MODULE__{topic | handler: self()}
    path = "pubsub/sub?arg=#{topic.base64url_topic}"
    ApiStreamingClient.new(self(), path)
    {:ok, state}
  end

  @spec is_subscribed?(pid, binary) :: boolean
  def is_subscribed?(subscriber, topic) when is_pid(subscriber),
    do:
      topic
      |> via_tuple()
      |> GenServer.call({:is_subscribed, subscriber})

  @spec subscribe(pid, binary) :: :ok
  def subscribe(subscriber, topic) when is_pid(subscriber),
    do:
      topic
      |> via_tuple()
      |> GenServer.cast({:add_subscriber, subscriber})

  @spec unsubscribe(pid, binary) :: :ok
  def unsubscribe(subscriber, topic) when is_pid(subscriber) and is_binary(topic),
    do:
      topic
      |> via_tuple()
      |> GenServer.cast({:remove_subscriber, subscriber})

  @spec handler(binary) :: pid | nil
  def handler(topic) when is_binary(topic),
    do:
      topic
      |> via_tuple
      |> GenServer.call(:handler)

  # Server callbacks

  def handle_call({:is_subscribed, subscriber}, _from, state) do
    state = refresh(state)
    {:reply, MapSet.member?(state.subscribers, subscriber), state}
  end

  def handle_call(:handler, _from, state) do
    {:reply, state.handler, state}
  end

  def handle_call(data, _from, state) do
    Logger.info("Handle Call received data: #{inspect(data)}")
    {:reply, :ok, state}
  end

  @spec handle_cast(any, any, any) :: none
  def handle_cast({:add_subscriber, subscriber}, _from, state) do
    state = refresh(state)
    state = %__MODULE__{state | subscribers: MapSet.put(state.subscribers, subscriber)}
    {:reply, :ok, state}
  end

  def handle_cast({:remove_subscriber, subscriber}, _from, state) do
    state = refresh(state)
    {:reply, :ok, %__MODULE__{state | subscribers: MapSet.delete(state.subscribers, subscriber)}}
  end

  def handle_cast(:subscribe, state) do
    Logger.info("Starting subscription for #{state.topic}")

    url = "#{@api_url}/pubsub/sub?arg=#{state.base64url_topic}"

    # Set self( ) as the target for the ApiStreamingClient
    # Well extract the end target, when parsed.
    ApiStreamingClient.new(
      self(),
      url,
      :infinity
    )

    {:noreply, state}
  end

  def handle_cast(data, state) do
    Logger.info("Received data: #{inspect(data)}")
    {:noreply, state}
  end

  def handle_info({:hackney_response, _ref, data}, state) do
    case data do
      {:status, 200, _} ->
        Logger.info("Subscribed to #{state.topic}")
        {:noreply, state}

      {:headers, headers} ->
        Logger.info("Headers: #{inspect(headers)}")
        {:noreply, state}

      {:data, data} ->
        Logger.info("Data: #{inspect(data)}")
        {:noreply, state}

      {:done, _} ->
        Logger.info("Done")
        {:noreply, state}

      data ->
        Logger.info("Received data: #{inspect(data)}")

        send(
          state.target,
          parse_pubsub_message(data)
        )

        {:noreply, state}
    end

    {:noreply, state}
  end

  defp via_tuple(topic) when is_binary(topic) do
    Logger.debug("Registering via tuple for #{topic}")
    {:via, Registry, {@registry, topic}}
  end

  defp parse_pubsub_message(data) do
    message = Message.new(data)
    {:ex_ipfs_pubsub_sub_message, Multibase.decode!(message.data)}
  end

  defp refresh(topic) do
    Map.put(topic, :subscribers, Enum.filter(topic.subscribers, &Process.alive?/1))
  end
end
