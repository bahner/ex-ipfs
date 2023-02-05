defmodule MyspaceIPFS.Dht do
  @moduledoc """
  MyspaceIPFS.Dht is where the dht commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

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
  @spec query(MyspaceIPFS.peer_id()) ::
          {:ok, MyspaceIPFS.peer_id()} | MyspaceIPFS.Api.error_response()
  def query(peer_id) do
    post_query("/dht/query?arg=" <> peer_id)
    |> okify()
  end
end
