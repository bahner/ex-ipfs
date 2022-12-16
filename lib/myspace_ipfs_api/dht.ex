defmodule MyspaceIPFS.Api.Dht do
    @moduledoc """
  MyspaceIPFS.Api is where the dht commands of the IPFS API reside.
  """

    # DHT COMMANDS
    # NB: dht_findpeer is deprecated.
    # NB: dht_findprovs is deprecated.
    # NB: dht_get is deprecated.
    # NB: dht_provide is deprecated.
    # NB: dht_put is deprecated.

    def dht_query(peer_id), do: request_get("/dht/query?arg=", peer_id)

end
