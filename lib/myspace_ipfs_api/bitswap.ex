defmodule MyspaceIPFS.Api.Bitswap do
  @moduledoc """
  MyspaceIPFS.Api.Bitswap is where the bootstrap commands of the IPFS API reside.
  """
  import MyspaceIPFS.Utils

  def ledger(peer_id), do: request_get("/bitswap/ledger?arg=", peer_id)

  def stat, do: request_get("/bitswap/stat")

  def unwant(keys), do: request_get("/bitswap/unwant?arg=", keys)

  def wantlist(peer \\ "") do
    if peer != "" do
      request_get("/bitswap/wantlist?peer", peer)
    else
      request_get("/bitswap/wantlist")
    end
  end
end
