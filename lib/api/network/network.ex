defmodule MyspaceIPFS.Api.Network do
  @moduledoc """
  MyspaceIPFS.Api.Bitswap is where the bootstrap commands of the IPFS API reside.
  """
  import MyspaceIPFS

  @doc """
  Show the id of the IPFS node.
  """
  def id, do: post_query("/id")

  @doc """
  Ping a peer.
  """
  def ping(id), do: post_query("/ping?arg=" <> id)
end
