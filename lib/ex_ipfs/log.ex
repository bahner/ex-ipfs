defmodule ExIPFS.Log do
  @moduledoc """
  ExIPFS.Log is where the log commands of the IPFS API reside.
  """
  import ExIPFS.Api
  import ExIPFS.Utils
  alias ExIPFS.Strings

  @doc """
  Change the logging level.

  ## Parameters
  https://docs.ipfs.io/reference/http/api/#api-v0-log-level
    `subsys` - Subsystem logging identifier.
    `level` - Logging level.
  """
  @spec level(binary(), binary()) :: {:ok, any} | ExIPFS.Api.error_response()
  def level(subsys \\ "all", level) do
    post_query("/log/level?arg=" <> subsys <> "&arg=" <> level)
    |> okify()
  end

  @doc """
  List the logging subsystems.
  """
  @spec ls() :: {:ok, any} | ExIPFS.Api.error_response()
  def ls do
    post_query("/log/ls")
    |> Strings.new()
    |> okify()
  end

  @doc """
  Read the event log. Currently broken. See https://github.com/ipfs/kubo/issues/9245
  """
  @spec tail(pid) :: {:ok, pid} | :ok | ExIPFS.Api.error_response()
  def tail(_pid) do
    IO.puts("Currently broken. See https://github.com/ipfs/kubo/issues/9245")
    # ExIPFS.LogTail.start_link(pid)
    :ok
  end
end
