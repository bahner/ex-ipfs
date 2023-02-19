defmodule MyspaceIPFS.PubSub.Channel do
  @moduledoc false
  use GenServer, restart: :transient
  require Logger
  import MyspaceIPFS.Utils
  alias MyspaceIPFS.Multibase
  alias MyspaceIPFS.PubSub.ChannelMessage, as: Message

  @enforce_keys [:topic, :target]
  defstruct base64url_topic: nil, client: nil, raw: false, target: nil, topic: nil

  @type t :: %__MODULE__{
          base64url_topic: binary | nil,
          client: reference | nil,
          raw: boolean | nil,
          target: pid | atom,
          topic: binary
        }

  @api_url Application.compile_env(:myspace_ipfs, :api_url, "http://localhost:5001/api/v0")

  @spec start_link(t(), list) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(channel, opts \\ []) do
    GenServer.start_link(
      __MODULE__,
      channel,
      opts
    )
  end

  @spec init(t()) :: {:ok, t()}
  def init(channel) do
    Logger.debug("Initializing channel #{inspect(channel)}")
    url = "#{@api_url}/pubsub/sub?arg=#{channel.base64url_topic}"
    Logger.debug("Subscribing to #{url}")
    {:ok, ref} = spawn_client(self(), url)
    Logger.debug("Subscribed to #{url} with #{inspect(ref)}")
    {:ok, %{channel | client: ref}}
  end

  @spec new!(pid | atom, binary, boolean) :: t()
  def new!(target, topic, raw \\ false) do
    %__MODULE__{
      base64url_topic: Multibase.encode!(topic),
      client: nil,
      raw: raw,
      target: target,
      topic: topic
    }
  end

  @spec new(pid, binary, boolean) :: {:ok, t()}
  def new(target, topic, raw \\ false) do
    {:ok, new!(target, topic, raw)}
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

  # This is probably where we want to decrypt the message
  defp parse_pubsub_message(data) do
    message = Message.new(data)
    {:myspace_ipfs_pubsub_channel_message, Multibase.decode!(message.data)}
  end
end
