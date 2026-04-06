defmodule ExIpfs.Ping do
  @moduledoc false
  use GenServer

  require Logger

  alias ExIpfs.ApiStreamingClient

  @type request :: %ExIpfs.PingRequest{
          request_id: binary,
          pid: pid,
          peer_id: ExIpfs.peer_id(),
          timeout: atom | integer,
          query_options: list
        }

  @type reply :: %ExIpfs.PingReply{
          success: boolean,
          time: non_neg_integer,
          text: binary
        }

  @api_url Application.compile_env(:ex_ipfs, :api_url, "http://127.0.0.1:5001/api/v0")

  # No good way to test this, so we'll just ignore it for coverage
  # coveralls-ignore-start
  @spec start_link(request, list) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(request, opts) do
    Logger.info("Starting ping server for #{request.peer_id}")

    GenServer.start_link(
      __MODULE__,
      request,
      opts
    )
  end

  @spec init(map) :: {:ok, map}
  def init(state) when is_map(state) do
    handle_cast({:new_request, state}, state)
    {:ok, state}
  end

  @spec new(request()) :: any
  def new(request) do
    start_link(request, name: String.to_atom(request.request_id))
  end

  def handle_cast({:new_request, request}, state) do
    Logger.info("Starting ping for #{request.peer_id}")

    url = "#{@api_url}/ping?arg=#{request.peer_id}"

    ApiStreamingClient.new(
      self(),
      url,
      request.timeout,
      request.query_options
    )

    {:noreply, state}
  end

  def handle_info({:hackney_response, _ref, data}, state) do
    case data do
      {:status, 200, _} ->
        Logger.info("Status 200 starting pinging #{state.peer_id}")
        {:noreply, state}

      {:headers, headers} ->
        Logger.info("Headers: #{inspect(headers)}")
        {:noreply, state}

      :done ->
        {:stop, state}

      data ->
        Logger.info("Received data: #{inspect(data)}")

        send(
          state.pid,
          try do
            JSON.decode!("#{data}")
            |> ExIpfs.PingReply.new()
          rescue
            _ -> data
          end
        )

        {:noreply, state}
    end

    {:noreply, state}
  end

  # coveralls-ignore-stop
end
