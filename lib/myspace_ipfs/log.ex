defmodule MyspaceIPFS.Log do
  @moduledoc """
  MyspaceIPFS.Log is where the log commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @doc """
  Change the logging level.

  ## Parameters
  https://docs.ipfs.io/reference/http/api/#api-v0-log-level
    `subsys` - Subsystem logging identifier.
    `level` - Logging level.
  """
  @spec level(binary(), binary()) :: {:ok, any} | MyspaceIPFS.Api.error_response()
  def level(subsys \\ "all", level) do
    post_query("/log/level?arg=" <> subsys <> "&arg=" <> level)
    |> okify()
  end

  @doc """
  List the logging subsystems.
  """
  @spec ls() :: {:ok, any} | MyspaceIPFS.Api.error_response()
  def ls do
    post_query("/log/ls")
    |> okify()
  end

  @doc """
  Read the event log.
  """
  @spec tail() :: {:ok, any} | MyspaceIPFS.Api.error_response()
  def tail do
    post_query("/log/tail")
    |> okify()
  end
end
