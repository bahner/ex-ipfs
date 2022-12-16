defmodule MyspaceIPFS.Api.Filestore do
    @moduledoc """
  MyspaceIPFS.Api is where the filestore commands of the IPFS API reside.
  """

    def filestore_dups, do: request_get("/filestore/dups")

    def filestore_ls, do: request_get("/filestore/ls")

    def filestore_verify, do: request_get("/filestore/verify")
end
