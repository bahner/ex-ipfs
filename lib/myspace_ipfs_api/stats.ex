defmodule MyspaceIPFS.Api.Stats do
    @moduledoc """
  MyspaceIPFS.Api.Stats is where the stats commands of the IPFS API reside.
  """

    def stats_bitswap, do: request_get("/stats/bitswap")

    def stats_bw, do: request_get("/stats/bw")

    def stats_repo, do: request_get("/stats/repo")
end
