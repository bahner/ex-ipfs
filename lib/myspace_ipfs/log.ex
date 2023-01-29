defmodule MyspaceIpfs.Log do
  @moduledoc """
  MyspaceIpfs.Log is where the log commands of the IPFS API reside.
  """
  import MyspaceIpfs.Api
  import MyspaceIpfs.Utils

  @typep okresult :: MyspaceIpfs.okresult()
  @typep name :: MyspaceIpfs.name()

  @doc """
  Change the logging level.

  ## Parameters
  https://docs.ipfs.io/reference/http/api/#api-v0-log-level
    `subsys` - Subsystem logging identifier.
    `level` - Logging level.
  """
  @spec level(name, name) :: okresult
  def level(subsys \\ "all", level) do
    post_query("/log/level?arg=" <> subsys <> "&arg=" <> level)
    |> okify()
  end

  @doc """
  List the logging subsystems.
  """
  @spec ls() :: okresult
  def ls do
    post_query("/log/ls")
    |> okify()
  end

  @doc """
  Read the event log.
  """
  @spec tail() :: okresult
  def tail do
    post_query("/log/tail")
    |> okify()
  end
end
