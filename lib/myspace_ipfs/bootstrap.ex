defmodule MyspaceIpfs.Bootstrap do
  @moduledoc """
  MyspaceIpfs.Bootstrap is where the bootstrap commands of the IPFS API reside.
  """

  defstruct Peers: []

  import MyspaceIpfs.Api

  @type t :: %__MODULE__{
          Peers: List.t()
        }
  @typep reply :: {:ok, [t()]} | {:error, any()}

  @doc """
  List peers in bootstrap list.
  """
  @spec bootstrap() :: reply
  def bootstrap do
    post_query("/bootstrap")
    |> handle_api_response()
  end

  @doc """
  Add peers to the bootstrap list.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bootstrap-add
  `peer` - The peer ID to add to the bootstrap list. The format is a multiaddr
  in the form of `<multiaddr>/<peerID>`
  """
  @spec add(binary) :: reply
  def add(peer) do
    post_query("/bootstrap/add?arg=" <> peer)
    |> handle_api_response()
  end

  @doc """
  Add default peers to the bootstrap list.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bootstrap-add-default
  """
  @spec add_default() :: reply
  def add_default do
    post_query("/bootstrap/add/default")
    |> handle_api_response()
  end

  @doc """
  Show peers in bootstrap list.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bootstrap-list
  """
  @spec list() :: reply
  def list do
    post_query("/bootstrap/list")
    |> handle_api_response()
  end

  @doc """
  Remove peer to the bootstrap list.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bootstrap-rm
  `peer` - The peer ID to remove from the bootstrap list. The format is a multiaddr
  in the form of `<multiaddr>/<peerID>`

  """
  @spec rm(binary) :: reply
  def rm(peer) do
    post_query("/bootstrap/rm?arg=" <> peer)
    |> handle_api_response()
  end

  @doc """
  Remove all peers from the bootstrap list.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bootstrap-rm-all
  """
  @spec rm_all() :: reply
  def rm_all do
    post_query("/bootstrap/rm/all")
    |> handle_api_response()
  end
end
