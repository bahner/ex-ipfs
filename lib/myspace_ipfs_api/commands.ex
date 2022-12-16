defmodule MyspaceIPFS.Api.Commands do
    @moduledoc """
  MyspaceIPFS.Api.Commands is where the commands commands of the IPFS API reside.
  """

    def commands, do: request_get("/commands")

    def completion(shell), do: request_get("/commands/completion/" <> shell)

end
