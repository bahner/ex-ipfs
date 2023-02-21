defmodule ExIPFS.DiagProfile do
  @moduledoc false
  use GenServer

  require Logger
  import ExIPFS.Utils

  defstruct ref: nil,
            output: nil,
            query_options: nil,
            writer: nil,
            timeout: "30s"

  @type t :: %__MODULE__{
          output: Path.t(),
          timeout: binary,
          writer: pid,
          ref: reference,
          query_options: list
        }

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  def new(opts) do
    %__MODULE__{
      output: opts["Output"],
      timeout: opts["Timeout"],
      writer: opts["Writer"],
      ref: opts["Ref"],
      query_options: opts["QueryOptions"]
    }
  end

  @api_url Application.compile_env(:ex_ipfs, :api_url, "http://localhost:5001/api/v0")

  @spec start_link(list) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(query_options) do
    GenServer.start_link(
      __MODULE__,
      %__MODULE__{query_options: query_options}
    )
  end

  @spec init(map) :: {:ok, map}
  def init(state) do
    url = "#{@api_url}/diag/profile"

    # Update state with the  output filename from the query options, or use a default.
    output = Keyword.get(state.query_options, :output, "ipfs-profile-#{timestamp()}.zip")
    state = %{state | output: output}

    # Delete the output file if it already exists.
    if File.exists?(output) do
      Logger.info("Output file #{output} already exists. Delete existing file.")
      File.rm!(output)
    end

    timeout = Keyword.get(state.query_options, :"profile-time", "20s")
    state = %{state | timeout: timeout}
    # Spawn the client and update the state with the reference.
    # Set hackney to something other than :infinity to timeout.
    Logger.debug(
      "Spawning client with url #{url} and query options #{inspect(state.query_options)}"
    )

    case spawn_client(self(), url, :infinity, state.query_options) do
      {:ok, ref} ->
        {:ok, writer} = File.open(output, [:write])
        {:ok, %{state | ref: ref, writer: writer}}

      {:error, reason} ->
        {:stop, {:error, reason}}
    end
  end

  def handle_info({:hackney_response, _ref, data}, state) do
    case data do
      {:ok, pid} ->
        Logger.info("Client started with pid #{inspect(pid)}")
        {:noreply, state}

      {:status, 200, _} ->
        Logger.info("Profiling. Please wait at least #{state.timeout}.")
        Logger.debug("Profile will be saved to #{state.output}")
        {:noreply, state}

      {:headers, headers} ->
        Logger.debug("Headers: #{inspect(headers)}")
        {:noreply, state}

      :done ->
        File.close(state.writer)
        Logger.info("Profile saved to #{state.output}")
        {:stop, :normal, state}

      data ->
        IO.binwrite(state.writer, data)
        {:noreply, state}
    end

    {:noreply, state}
  end
end
