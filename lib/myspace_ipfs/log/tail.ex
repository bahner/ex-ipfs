defmodule MyspaceIpfs.Log.Tail do
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

  # @api_url Application.get_env(:myspace_ipfs, :api_url)
  # @default_topic Application.get_env(:myspace_ipfs, :default_topic)
  @api_url Application.compile_env(:myspace_ipfs, :api_url, "http://localhost:5001/api/v0")

  @spec start_link(pid) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(pid) do
    GenServer.start_link(
      __MODULE__,
      %{target: pid, client: nil}
    )
  end

  @spec init(map) :: {:ok, %{target: pid, client: reference}}
  def init(state) do
    url = "#{@api_url}/log/tail"
    {:ok, ref} = spawn_client(self(), url, :infinity, [])
    {:ok, %{state | client: ref}}
  end

  def stop(pid, reason \\ :normal, timeout \\ :infinity) do
    GenServer.stop(pid, reason, timeout)
  end

  def handle_info({:hackney_response, _ref, data}, state) do
    case data do
      {:status, 200, _} ->
        Logger.info("Connected to log/tail")
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
          data
        )

        {:noreply, state}
    end

    {:noreply, state}
  end
end
