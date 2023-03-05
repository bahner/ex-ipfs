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

  @spec start_link({binary, list(pid)}, list) :: :ignore | {:error, any} | {:ok, pid}
  def start_link({topic, subscribers}, _opts) when is_binary(topic) and is_list(subscribers)do
    Logger.debug("Starting topic handler for #{topic}")

    GenServer.start_link(
      __MODULE__,
      {topic, subscribers})
  end

  @spec init({binary, maybe_improper_list}) :: {:ok, t()}
  def init({topic, subscribers}) when is_binary(topic) and is_list(subscribers) do

    state = get_or_create_topic(topic, self(), subscribers)

    {:ok, state}
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

  def handle_cast(:new_sub, state) do
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

  defp get_or_create_topic(topic, subscribers) do
    case ExIpfsPubsub.Topics.get(topic) do
      nil -> new!(topic, self(), subscribers)
      topic -> topic
    end
  end

  defp parse_pubsub_message(data) do
    message = TopicMessage.new(data)
    {:ex_ipfs_pubsub_sub_message, Multibase.decode!(message.data)}
  end
end
