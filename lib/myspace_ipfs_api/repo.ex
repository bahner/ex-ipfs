defmodule MyspaceIPFS.Api.Repo do
    @moduledoc """
  MyspaceIPFS.Api.Repo is where the repo commands of the IPFS API reside.
  """

    ##Currently throws an error due to the size of JSON response.
    def repo_verify, do: request_get("/repo/verify")

    def repo_version, do: request_get("/repo/version")

    def repo_stat, do: request_get("/repo/stat")

    def repo_gc, do: request_get("/repo/gc")

end
