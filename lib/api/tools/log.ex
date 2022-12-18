defmodule MyspaceIPFS.Api.Tools.Log do
  @moduledoc """
  MyspaceIPFS.Api.Log is where the log commands of the IPFS API reside.
  """
  import MyspaceIPFS

  @spec level(binary, binary) :: any
  def level(subsys, level),
    do: post_query("/log/level?arg=" <> subsys <> "&arg=" <> level)

  @spec ls :: any
  def ls, do: post_query("/log/ls")

  @spec tail :: any
  def tail, do: post_query("/log/tail")
end
