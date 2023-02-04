defmodule MyspaceIPFS.Dht do
  @moduledoc """
  MyspaceIPFS.Dht is where the dht commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @typep peer_id :: MyspaceIPFS.peer_id()
  @typep api_error :: MyspaceIPFS.ApiError.t()

  @doc """
  Find the closest peers to a given key.

  ## Parameters
  `peer_id` - The peer ID to find the closest peers to.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-dht-query
  ```
  [
    `verbose` - <bool>, # Print extra information.
  ]
  ```
  """
  # FIXME: return a proper struct
  @spec query(peer_id) :: {:ok, peer_id()} | api_error()
  def query(peer_id) do
    post_query("/dht/query?arg=" <> peer_id)
    |> okify()
  end
end
