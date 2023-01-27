defmodule MyspaceIpfs.Ping do
  @moduledoc false
  use GenServer

  require Logger
  import MyspaceIpfs.Utils

  defstruct success: nil, time: nil, text: nil

  @type t :: %__MODULE__{
          success: boolean,
          time: non_neg_integer,
          text: binary
        }
  @typep peer_id :: MyspaceIpfs.peer_id()

  # @api_url Application.get_env(:myspace_ipfs, :api_url)
  # @default_topic Application.get_env(:myspace_ipfs, :default_topic)
  @api_url Application.compile_env(:myspace_ipfs, :api_url, "http://localhost:5001/api/v0")

  @spec start_link(pid, peer_id, :atom | integer, list) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(pid, peer_id, timeout, query_options) do
    GenServer.start_link(
      __MODULE__,
      %{pid: pid, peer_id: peer_id, ref: nil, timeout: timeout, query_options: query_options}
    )
  end

  @spec init(map) :: {:ok, map}
  def init(state) do
    query_options = URI.encode_query(state.query_options)
    url = "#{@api_url}/ping?arg=#{state.peer_id}&" <> query_options
    {:ok, ref} = spawn_client(self(), url, state.timeout)
    {:ok, %{state | ref: ref}}
  end

  def handle_info({:hackney_response, _ref, data}, state) do
    case data do
      {:status, 200, _} ->
        Logger.info("Status 200 starting pinging #{state.peer_id}")
        {:noreply, state}

      {:headers, headers} ->
        Logger.info("Headers: #{inspect(headers)}")
        {:noreply, state}

      {:done, _} ->
        Logger.info("Done")
        {:noreply, state}

      data ->
        Logger.info("Received data: #{inspect(data)}")

        send(
          state.pid,
          try do
            Jason.decode!("#{data}")
            |> snake_atomize()
            |> new()
          rescue
            _ -> data
          end
        )

        {:noreply, state}
    end

    {:noreply, state}
  end

  defp new(opts) do
    %MyspaceIpfs.Ping{}
    |> struct(opts)
  end
end
