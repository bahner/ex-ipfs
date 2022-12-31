defmodule MyspaceIPFS.Bootstrap do
  @moduledoc """
  MyspaceIPFS.Bootstrap is where the bootstrap commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @typep okmapped :: MySpaceIPFS.okmapped()

  @doc """
  List peers in bootstrap list.
  """
  @spec bootstrap() :: okmapped()
  def bootstrap do
    post_query("/bootstrap")
    |> handle_response_data()
  end

  @doc """
  Add peers to the bootstrap list.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bootstrap-add
  `peer` - The peer ID to add to the bootstrap list. The format is a multiaddr
  in the form of `<multiaddr>/<peerID>`
  """
  @spec add(binary) :: okmapped()
  def add(peer) do
    post_query("/bootstrap/add?arg=" <> peer)
    |> handle_response_data()
  end

  @doc """
  Add default peers to the bootstrap list.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bootstrap-add-default
  """
  @spec add_default() :: okmapped()
  def add_default do
    post_query("/bootstrap/add/default")
    |> handle_response_data()
  end

  @doc """
  Show peers in bootstrap list.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bootstrap-list
  """
  @spec list() :: okmapped()
  def list, do: post_query("/bootstrap/list")

    @doc """
  Remove peer to the bootstrap list.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bootstrap-rm
  `peer` - The peer ID to remove from the bootstrap list. The format is a multiaddr
  in the form of `<multiaddr>/<peerID>`

  """
  @spec rm(binary) :: okmapped()
  def rm(peer) do
    post_query("bootstrap/rm?arg=" <> peer)
    |> handle_response_data()
  end

  @doc """
  Remove all peers from the bootstrap list.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bootstrap-rm-all
  """
  @spec rm_all() :: okmapped()
  def rm_all do
    post_query("bootstrap/rm/all")
    |> handle_response_data()
  end
end
