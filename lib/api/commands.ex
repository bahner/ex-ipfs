defmodule MyspaceIPFS.Api.Commands do
  @moduledoc """
  MyspaceIPFS.Api.Commands is where the commands commands of the IPFS API reside.
  """
  import MyspaceIPFS

  def commands, do: post_query("/commands")

  def completion(shell), do: post_query("/commands/completion/" <> shell)
end
