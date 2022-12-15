defmodule MyspaceIPFS.Api.Tools.Log do
  @moduledoc """
  MyspaceIPFS.Api.Log is where the log commands of the IPFS API reside.
  """

  import MyspaceIPFS.Utils

  @spec level(binary, binary) :: any
  def level(subsys, level),
    do: request_get("/log/level?arg=" <> subsys <> "&arg=" <> level)

  @spec ls :: any
  def ls, do: request_get("/log/ls")

  @spec tail :: any
  def tail, do: request_get("/log/tail")
end
