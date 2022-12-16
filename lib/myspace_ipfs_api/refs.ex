defmodule MyspaceIPFS.Api.Refs do
    @moduledoc """
  MyspaceIPFS.Api.Refs is where the main commands of the IPFS API reside.
  """

    # FIXME: refs is not implemented yet.

    def refs_local, do: request_get("/refs/local")
end
