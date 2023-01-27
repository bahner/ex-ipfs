defmodule MyspaceIpfs.PubSubChannel do
  @moduledoc """
  MyspaceIpfs.PubSubChannel is a GenServer that subscribes to a topic and
  forwards messages to a target process.

  The topic *must* be a base64 encoded string, but we will encode it for you.

  ## Options
    raw: true | false
      If true, the message will be sent to the target process as a
      MyspaceIpfs.PubSubChannelMessage struct containing the message data and the topic.
      If false, only the message
      data will be sent to the target process.

  ## Example
      iex> {:ok, pid} = MyspaceIpfs.PubSubChannel.start_link(self(), "mytopic")
      iex> MyspaceIpfs.PubSub.pub("mytopic", "Hello, world!")
      iex> flush()
      "Hello, world!"
      :ok
  """
  use GenServer

  require Logger

  import MyspaceIpfs.Utils

  alias MyspaceIpfs.Multibase

  @enforce_keys [:topic, :target]
  defstruct topic: nil, target: nil, base64url_topic: nil, client: nil, raw: false

  @type t :: %__MODULE__{
          topic: binary,
          target: pid,
          base64url_topic: binary,
          client: any,
          raw: boolean
        }

  @doc """
  Generate a PubSubChannel struct from a map or passthrough an error message
  from the IPFS API
  """
  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: t()
  def new(map) do
    %__MODULE__{
      topic: map.topic,
      target: map.target,
      base64url_topic: map.base64url_topic,
      client: map.client,
      raw: map.raw
    }
  end

  # @api_url Application.get_env(:myspace_ipfs, :api_url)
  # @default_topic Application.get_env(:myspace_ipfs, :default_topic)
  @api_url Application.compile_env(:myspace_ipfs, :api_url, "http://localhost:5001/api/v0")

  @spec start_link(pid, binary) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(pid, topic) do
    GenServer.start_link(
      __MODULE__,
      create_channel(topic, pid)
    )
  end

  @spec start_link(pid, binary, list) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(pid, topic, options) do
    GenServer.start_link(
      __MODULE__,
      create_channel(topic, pid, options)
    )
  end

  defp create_channel(topic, target, options \\ []) do
    # Takes options and merges them with the required struct and
    # makes sure there is a base64url_topic, that is properly encoded
    Enum.into(
      options,
      %MyspaceIpfs.PubSubChannel{
        topic: topic,
        target: target,
        base64url_topic: unokify(Multibase.encode(topic))
      }
    )
  end

  @spec init(t) :: {:ok, t}
  def init(channel) do
    Logger.debug("Initializing channel #{inspect(channel)}")
    url = "#{@api_url}/pubsub/sub?arg=#{channel.base64url_topic}"
    Logger.debug("Subscribing to #{url}")
    {:ok, ref} = spawn_client(self(), url, :infinity, channel.options)
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

defmodule MyspaceIpfs.PubSubChannelMessage do
  @moduledoc """
  MyspaceIpfs.PubSubChannelMessage is a struct that represents a message as it
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
