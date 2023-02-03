defmodule MyspaceIPFS.Bootstrap do
  @moduledoc """
  MyspaceIPFS.Bootstrap is where the bootstrap commands of the IPFS API reside.
  """

  defstruct Peers: []

  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils
  alias MyspaceIPFS.Peers

  @type t :: %__MODULE__{
          Peers: list
        }
  @typep reply :: {:ok, [t()]} | {:error, any()}
  @typep path :: MyspaceIPFS.path()

  @doc """
  List peers in bootstrap list.
  """
  @spec bootstrap() :: {:ok, MyspaceIPFS.Peers.t()}
  def bootstrap do
    post_query("/bootstrap")
    |> snake_atomize()
    |> Peers.new()
    |> okify()
  end

  @doc """
  Add peers to the bootstrap list.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bootstrap-add
  `peer` - The peer ID to add to the bootstrap list. The format is a multiaddr
  in the form of `<multiaddr>/<peerID>`
  """
  @spec add(path) :: {:ok, MyspaceIPFS.Peers.t()}
  def add(peer) do
    post_query("/bootstrap/add?arg=" <> peer)
    |> snake_atomize()
    |> Peers.new()
    |> okify()
  end

  @doc """
  Add default peers to the bootstrap list.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bootstrap-add-default
  """
  @spec add_default() :: {:ok, MyspaceIPFS.Peers.t()}
  def add_default do
    post_query("/bootstrap/add/default")
    |> snake_atomize()
    |> Peers.new()
    |> okify()
  end

  @doc """
  Show peers in bootstrap list.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bootstrap-list
  """
  @spec list() :: {:ok, MyspaceIPFS.Peers.t()}
  def list do
    post_query("/bootstrap/list")
    |> snake_atomize()
    |> Peers.new()
    |> okify()
  end

  @doc """
  Remove peer to the bootstrap list.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bootstrap-rm
  `peer` - The peer ID to remove from the bootstrap list. The format is a multiaddr
  in the form of `<multiaddr>/<peerID>`

  """
  @spec rm(path) :: {:ok, MyspaceIPFS.Peers.t()}
  def rm(peer) do
    post_query("/bootstrap/rm?arg=" <> peer)
    |> snake_atomize()
    |> Peers.new()
    |> okify()
  end

  @doc """
  Remove all peers from the bootstrap list.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bootstrap-rm-all
  """
  @spec rm_all() :: reply
  def rm_all do
    post_query("/bootstrap/rm/all")
  end
end
