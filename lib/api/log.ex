defmodule MyspaceIPFS.Api.Log do
  @moduledoc """
  MyspaceIPFS.Api.Log is where the log commands of the IPFS API reside.
  """
  import MyspaceIPFS

  def level(subsys, level),
    do: post_query("/log/level?arg=" <> subsys <> "&arg=" <> level)

  def ls, do: post_query("/log/ls")

  def tail, do: post_query("/log/tail")
end
