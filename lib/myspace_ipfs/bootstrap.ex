defmodule MyspaceIPFS.Bootstrap do
  @moduledoc """
  MyspaceIPFS.Bootstrap is where the bootstrap commands of the IPFS API reside.

  When you start an IPFS node, it will not necessarily know about any other peers on the
  network. To find other peers, you need to connect to a bootstrap node. A bootstrap node
  is a node that is trusted to help you find other peers on the network. The IPFS daemon
  will connect to a bootstrap node automatically when it starts up.
  """

  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils
  alias MyspaceIPFS.Structs.Peers

  @doc """
  List peers in bootstrap list.
  """
  @spec bootstrap() :: {:ok, MyspaceIPFS.peers()} | MyspaceIPFS.Api.error_response()
  def bootstrap do
    post_query("/bootstrap")
    |> Peers.new()
    |> okify()
  end

  @doc """
  Add peers to the bootstrap list.

  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bootstrap-add

  ## Parameters
  `peer` - The peer ID to add to the bootstrap list. The format is a multiaddr
  in the form of `<multiaddr>/<peerID>` OR a list of peers.
  """
  @spec add(Path.t()) :: {:ok, MyspaceIPFS.peers()} | MyspaceIPFS.Api.error_response()
  def add(peer) when is_binary(peer) do
    post_query("/bootstrap/add?arg=" <> peer)
    |> Peers.new()
    |> okify()
  end

  def add(peers) when is_list(peers) do
    peers
    |> Enum.map(fn p -> add(p) end)
    |> okify()
  end

  @doc """
  Add peer to the default bootstrap list.

  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bootstrap-add-default

  ## Parameters
  `peer` - The peer ID to add to the bootstrap list. The format is a multiaddr

  in the form of `<multiaddr>/<peerID>` OR a list of peers.
  """
  @spec add_default(Path.t()) ::
          {:ok, MyspaceIPFS.peers()} | MyspaceIPFS.Api.error_response()
  def add_default(peer) when is_binary(peer) do
    post_query("/bootstrap/add?arg=" <> peer)
    |> Peers.new()
    |> okify()
  end

  def add_default(peers) when is_list(peers) do
    peers
    |> Enum.map(fn p -> add_default(p) end)
    |> okify()
  end

  @doc """
  Show peers in bootstrap list.

  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bootstrap-list

  NB! /bootstrap/list is the same as /bootstrap, but that doesn't work
  well with Elixir because of the same name as the module.
  """
  @spec list() :: {:ok, MyspaceIPFS.peers()} | MyspaceIPFS.Api.error_response()
  def list do
    post_query("/bootstrap/list")
    |> Peers.new()
    |> okify()
  end

  @doc """
  Remove peer to the bootstrap list.

  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bootstrap-rm

  ## Parameters
  `peer` - The peer ID to remove from the bootstrap list. The format is a multiaddr
  in the form of `<multiaddr>/<peerID>`

  """
  @spec rm(Path.t()) :: {:ok, MyspaceIPFS.peers()} | MyspaceIPFS.Api.error_response()
  def rm(peer) do
    post_query("/bootstrap/rm?arg=" <> peer)
    |> Peers.new()
    |> okify()
  end

  @doc """
  Remove all peers from the bootstrap list.

  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bootstrap-rm-all
  """
  @spec rm_all() :: {:ok, MyspaceIPFS.peers()} | MyspaceIPFS.Api.error_response()
  def rm_all do
    post_query("/bootstrap/rm/all")
    |> okify()
  end
end
