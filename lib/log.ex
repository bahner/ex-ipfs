defmodule MyspaceIPFS.Log do
  @moduledoc """
  MyspaceIPFS.Api.Log is where the log commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @typep okresult :: MyspaceIPFS.okresult()
  @typep name :: MyspaceIPFS.name()

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
    |> handle_json_response()
  end

  @doc """
  List the logging subsystems.
  """
  @spec ls() :: okresult
  def ls do
    post_query("/log/ls")
    |> handle_json_response()
  end

  @doc """
  Read the event log.
  """
  @spec tail() :: okresult
  def tail do
    post_query("/log/tail")
    |> handle_plain_response()
  end
end
