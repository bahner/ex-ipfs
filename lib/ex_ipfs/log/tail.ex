defmodule ExIPFS.LogTail do
  @moduledoc false
  use GenServer
  require Logger
  import ExIPFS.Utils

  # @api_url Application.get_env(:ex_ipfs, :api_url)
  # @default_topic Application.get_env(:ex_ipfs, :default_topic)
  @api_url Application.compile_env(:ex_ipfs, :api_url, "http://localhost:5001/api/v0")

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

  @spec stop(pid, atom | :normal, non_neg_integer | :infinity) :: :ok
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
          {:ex_ipfs_log_tail, data}
        )

        {:noreply, state}
    end

    {:noreply, state}
  end
end
