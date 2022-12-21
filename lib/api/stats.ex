defmodule MyspaceIPFS.Api.Stats do
  @moduledoc """
  MyspaceIPFS.Api.Stats is where the stats commands of the IPFS API reside.
  """
  import MyspaceIPFS

  def bitswap, do: post_query("/stats/bitswap")

  def bw, do: post_query("/stats/bw")

  def dht, do: post_query("/stats/dht")

  # FIXME: bw_peer is not implemented yet.
  # def bw, do: post_query("/stats/bw")

  def provide, do: post_query("/stats/provide")

  def repo, do: post_query("/stats/repo")
end
