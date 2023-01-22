defmodule MyspaceIPFS.PubSub.Channel do
  @moduledoc """
  MyspaceIPFS.PubSub.Channel is a GenServer that subscribes to a topic and
  forwards messages to a target process.

  The topic *must* be a base64 encoded string, but we will encode it for you.
  """
  use GenServer
  require Logger
  alias MyspaceIPFS.Multibase
  import MyspaceIPFS.Utils

  @enforce_keys [:topic, :target]
  defstruct topic: nil, target: nil, client: nil, base64url_topic: nil

  @type t :: %__MODULE__{
          topic: binary,
          target: pid,
          client: any,
          base64url_topic: binary
        }

  @api_url Application.get_env(:myspace_ipfs, :api_url)
  @default_topic Application.get_env(:myspace_ipfs, :default_topic)

  @spec start_link(pid, binary) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(pid, topic \\ @default_topic) do
    GenServer.start_link(
      __MODULE__,
      %MyspaceIPFS.PubSub.Channel{topic: topic, target: pid}
    )
  end

  @spec init(t) :: {:ok, t}
  def init(channel) do
    {:ok, base64url_topic} = Multibase.encode(channel.topic)
    {:ok, ref} = spawn_client(self(), base64url_topic)
    {:ok, %{channel | client: ref, base64url_topic: base64url_topic}}
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
    Jason.decode(data)
    |> data_from_tuple()
    |> (fn data -> Multibase.decode(data["data"]) end).()
    |> data_from_tuple()
    |> (fn data -> {:pubsub_sub, data} end).()
  end

  @spec spawn_client(pid, binary) :: any
  defp spawn_client(pid, topic) do
    options = [stream_to: pid, async: true, recv_timeout: :infinity]
    Logger.info("Subscribing to topic: #{topic} at #{@api_url}/pubsub/sub?arg=#{topic}")
    :hackney.request(:post, "#{@api_url}/pubsub/sub?arg=#{topic}", [], <<>>, options)
  end
end
