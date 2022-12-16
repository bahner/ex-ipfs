defmodule MyspaceIPFS.Api.Swarm do
    @moduledoc """
  MyspaceIPFS.Api.Swarm is where the swarm commands of the IPFS API reside.
  """

    def swarm_peers, do: request_get("/swarm/peers")

    def swarm_addrs_local, do: request_get("/swarm/addrs/local")

    def swarm_connect(multihash), do: request_get("/swarm/connect?arg=", multihash)

    def swarm_filters_add(multihash), do: request_get("/swarm/filters/add?arg=", multihash)

    def swarm_filters_rm(multihash), do: request_get("/swarm/filters/rm?arg=", multihash)

    def swarm_disconnect(multihash) when is_bitstring(multihash), do: request("/swarm/disconnect?arg=", multihash)
end
