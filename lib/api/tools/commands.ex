defmodule MyspaceIPFS.Api.Tools.Commands do
  @moduledoc """
  MyspaceIPFS.Api.Commands is where the commands commands of the IPFS API reside.
  """
  import MyspaceIPFS.Utils

  @spec commands :: any
  def commands, do: request_get("/commands")

  @spec completion(binary) :: any
  def completion(shell), do: request_get("/commands/completion/" <> shell)
end
