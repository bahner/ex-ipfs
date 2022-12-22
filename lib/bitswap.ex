defmodule MyspaceIPFS.Bitswap do
  @moduledoc """
  MyspaceIPFS.Api.Bitswap is where the bootstrap commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api

  @doc """
  Get the current bitswap ledger for a given peer.
  """
  def ledger(peer_id), do: post_query("/bitswap/ledger?arg=" <> peer_id)

  @doc """
  Get the current bitswap stats.
  """
  def stat(verbose \\ false, human \\ false),
    do:
      post_query(
        "/bitswap/stat?" <>
          "verbose=" <> to_string(verbose) <> "&" <> "human=" <> to_string(human)
      )

  @doc """
  Reprovide blocks to the network.
  """
  def reprovide, do: post_query("/bitswap/reprovide")

  @doc """
  Get the current bitswap wantlist.
  """
  def wantlist(peer \\ "") do
    if peer != "" do
      post_query("/bitswap/wantlist?peer", peer)
    else
      post_query("/bitswap/wantlist")
    end
  end
end
