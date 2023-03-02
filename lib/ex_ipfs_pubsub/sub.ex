defmodule ExIpfsPubsub.Sub do
  @moduledoc false

  use GenServer, restart: :transient

  require Logger
  alias ExIpfs.ApiStreamingClient
  alias ExIpfs.Multibase
  alias ExIpfsPubsub.Message

  @enforce_keys [:topic, :target]
  defstruct base64url_topic: nil, client: nil, raw: false, target: nil, topic: nil

  @type t :: %__MODULE__{
          base64url_topic: binary | nil,
          client: reference | nil,
          raw: boolean | nil,
          target: pid | atom,
          topic: binary
        }

  @api_url Application.compile_env(:ex_ipfs, :api_url, "http://localhost:5001/api/v0")

  @spec start_link(t, list) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(sub, opts \\ []) do
    GenServer.start_link(
      __MODULE__,
      sub,
      opts
    )
  end

  @spec init(map) :: {:ok, map}
  def init(state) when is_map(state) do
    handle_cast({:new_sub, state}, state)
    {:ok, state}
  end

  def handle_cast({:new_sub, sub}, state) do
    Logger.info("Starting subscription for #{sub.topic}")

    url = "#{@api_url}/Pubsub/sub?arg=#{sub.base64url_topic}"

    ApiStreamingClient.new(
      self(),
      url,
      sub.timeout,
      sub.query_options
    )

    {:noreply, state}
  end

  @spec new!(pid | atom, binary, boolean) :: t()
  def new!(target, topic, raw \\ false) do
    %__MODULE__{
      base64url_topic: Multibase.encode(topic, :base64url),
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
          parse_Pubsub_message(data)
        )

        {:noreply, state}
    end

    {:noreply, state}
  end

  # This is probably where we want to decrypt the message
  defp parse_Pubsub_message(data) do
    message = Message.new(data)
    {:myspace_ipfs_Pubsub_sub_message, Multibase.decode!(message.data)}
  end
end
