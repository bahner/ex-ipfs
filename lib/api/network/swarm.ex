defmodule MyspaceIPFS.Api.Network.Swarm do
  @moduledoc """
  MyspaceIPFS.Api.Swarm is where the swarm commands of the IPFS API reside.
  """

  import MyspaceIPFS

  def peers, do: post_query("/swarm/peers")

  def addrs, do: post_query("/swarm/addrs")

  def addrs_listen, do: post_query("/swarm/addrs/listen")

  def addrs_local, do: post_query("/swarm/addrs/local")

  def connect(multihash), do: post_query("/swarm/connect?arg=" <> multihash)

  def disconnect(multihash) when is_bitstring(multihash),
    do: post_query("/swarm/disconnect?arg=" <> multihash)

  def filters(), do: post_query("/swarm/filters")

  def filters_add(multihash), do: post_query("/swarm/filters/add?arg=" <> multihash)

  def filters_rm(multihash), do: post_query("/swarm/filters/rm?arg=" <> multihash)
end
