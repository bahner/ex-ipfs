defmodule ExIpfsPubsub.Topic do
  @moduledoc false

  use GenServer, restart: :transient

  require Logger
  alias ExIpfs.ApiStreamingClient
  alias ExIpfs.Multibase
  alias ExIpfsPubsub.TopicMessage

  @api_url Application.compile_env(:ex_ipfs, :api_url, "http://127.0.0.1:5001/api/v0")

  @enforce_keys [:base64url_topic, :handler, :subscribers, :topic]
  defstruct base64url_topic: nil, handler: nil, subscribers: MapSet.new(), topic: nil

  @type t :: %__MODULE__{
          base64url_topic: binary | nil,
          handler: pid | nil,
          subscribers: MapSet.t(pid),
          topic: binary
        }

  @spec start_link(t, list) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(topic, _opts) when is_struct(topic) do
    Logger.debug("Starting topic handler for #{topic}")

    GenServer.start_link(
      __MODULE__,
      topic,
      name: via_tuple(topic.topic)
    )
  end

  @spec init(binary) :: {:ok, t()} | {:stop, :already_registered}
  def init(topic) when is_struct(topic) do
    case ExIpfsPubsub.TopicRegistry.register_name(topic.topic, self()) do
      :yes -> {:ok, %__MODULE__{topic | handler: self()}}
      :no -> {:stop, :already_registered}
    end
  end

  @spec new!(binary, pid, list) :: t()
  def new!(topic, handler, subscribers)
      when is_pid(handler) and is_binary(topic) and is_list(subscribers) do
    %__MODULE__{
      base64url_topic: Multibase.encode!(topic, b: "base64url"),
      handler: handler,
      subscribers: MapSet.new(subscribers),
      topic: topic
    }
  end

  @spec subscribe(pid) :: :ok
  def subscribe(subscriber) when is_pid(subscriber),
    do: GenServer.cast(self(), {:add_subscriber, subscriber})

  @spec unsubscribe(pid) :: :ok
  def unsubscribe(subscriber) when is_pid(subscriber),
    do: GenServer.cast(self(), {:remove_subscriber, subscriber})

  @spec is_subscribed?(pid) :: boolean
  def is_subscribed?(subscriber) when is_pid(subscriber),
    do: GenServer.call(self(), {:is_subscribed?, subscriber})

  # Server callbacks

  def handle_call({:subscribed?, subscriber}, _from, state) do
    state = refresh(state)
    {:reply, MapSet.member?(state.subscribers, subscriber), state}
  end

  def handle_cast({:add_subscriber, subscriber}, _from, state) do
    state = refresh(state)
    {:reply, :ok, %__MODULE__{state | subscribers: MapSet.put(state.subscribers, subscriber)}}
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

  def handle_cast({:remove_subscriber, subscriber}, _from, state) do
    state = refresh(state)
    {:reply, :ok, %__MODULE__{state | subscribers: MapSet.delete(state.subscribers, subscriber)}}
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
    {:via, Registry, {ExIpfsPubsub.TopicRegistry, topic}}
  end

  defp parse_pubsub_message(data) do
    message = TopicMessage.new(data)
    {:ex_ipfs_pubsub_sub_message, Multibase.decode!(message.data)}
  end

  @spec refresh(t) :: t
  defp refresh(topic) do
    topic
    |> Map.put(:subscribers, Enum.filter(topic.subscribers, &Process.alive?/1))
  end

end
