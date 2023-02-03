defmodule MyspaceIPFS.PubSubChannel do
  @moduledoc """
  MyspaceIPFS.PubSubChannel is a GenServer that subscribes to a topic and
  forwards messages to a target process.

  The topic *must* be a base64 encoded string, but we will encode it for you.

  ## Options
    raw: true | false
      If true, the message will be sent to the target process as a
      MyspaceIPFS.PubSubChannelMessage struct containing the message data and the topic.
      If false, only the message
      data will be sent to the target process.

  ## Example
      iex> {:ok, pid} = MyspaceIPFS.PubSubChannel.start_link(self(), "mytopic")
      iex> MyspaceIPFS.PubSub.pub("mytopic", "Hello, world!")
      iex> flush()
      "Hello, world!"
      :ok
  """
  use GenServer

  require Logger

  import MyspaceIPFS.Utils

  alias MyspaceIPFS.Multibase

  @enforce_keys [:topic, :target]
  defstruct base64url_topic: nil, client: nil, raw: false, target: nil, topic: nil

  @type t :: %__MODULE__{
          base64url_topic: binary | nil,
          client: reference | nil,
          raw: boolean | nil,
          target: pid,
          topic: binary
        }

  @doc """
  Generate a PubSubChannel struct from a map or passthrough an error message
  from the IPFS API
  """
  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(pid, binary, boolean) :: t()
  def new(target, topic, raw) do
    %__MODULE__{
      base64url_topic: unokify(Multibase.encode(topic)),
      client: nil,
      raw: raw,
      target: target,
      topic: topic
    }
  end

  # @api_url Application.get_env(:myspace_ipfs, :api_url)
  # @default_topic Application.get_env(:myspace_ipfs, :default_topic)
  @api_url Application.compile_env(:myspace_ipfs, :api_url, "http://localhost:5001/api/v0")

  @spec start_link(pid, binary) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(pid, topic) do
    GenServer.start_link(
      __MODULE__,
      build_channel(pid, topic)
    )
  end

  @spec start_link(pid, binary, keyword) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(pid, topic, options) do
    GenServer.start_link(
      __MODULE__,
      build_channel(pid, topic, options)
    )
  end

  @spec build_channel(pid, binary, list) :: t()
  defp build_channel(target, topic, options \\ []) do
    new(target, topic, Keyword.get(options, :raw, false))
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
    message = struct(ChannelMessage, unokify(Jason.decode(data, keys: :atoms)))
    {:ipfs_pubsub_channel, Multibase.decode(message.data)}
  end
end

defmodule MyspaceIPFS.PubSubChannelMessage do
  @moduledoc """
  MyspaceIPFS.PubSubChannelMessage is a struct that represents a message as it
  is received from the IPFS pubsub API.
  """
  @enforce_keys [:from, :data, :seqno, :topic_ids]
  defstruct from: nil, data: nil, seqno: nil, topic_ids: nil

  @type t :: %__MODULE__{
          from: binary,
          data: binary,
          seqno: binary,
          topic_ids: list
        }
end
