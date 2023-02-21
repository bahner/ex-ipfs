defmodule ExIPFS.Dht do
  @moduledoc """
  ExIPFS.Dht is where the dht commands of the IPFS API reside.
  """
  import ExIPFS.Api
  import ExIPFS.Utils, only: [okify: 1]
  alias ExIPFS.DhtQueryResponse

  @typedoc """
  The response from the DHT Query command.
  """
  @type query_response() ::
          %ExIPFS.DhtQueryResponse{
            extra: binary(),
            id: ExIPFS.peer_id(),
            responses: list(query_response_addrs()),
            type: binary()
          }

  @typedoc """
  The response addresses list in the response from the DHT Query command.
  """
  @type query_response_addrs() ::
          %ExIPFS.DhtQueryResponseAddrs{
            addrs: list(Path.t()),
            id: ExIPFS.peer_id()
          }
  @doc """
  Find the closest peers to a given key.

  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-dht-query

  ## Parameters
  `peer_id` - The peer ID to find the closest peers to.

  ## Options
  ```
  [
    `timeout` - <string>, # The timeout for the request.
  ]
  ```
  """
  # FIXME: return a proper struct
  @spec query(ExIPFS.peer_id(), list) ::
          {:ok, query_response()} | ExIPFS.Api.error_response()
  def query(peer_id, opts \\ []) do
    with timeout <- Keyword.get(opts, :timeout, 10_000) do
      post_query("/dht/query?arg=" <> peer_id, opts: [adapter: [recv_timeout: timeout]])
      |> DhtQueryResponse.new()
      |> okify()
    end
  end
end
