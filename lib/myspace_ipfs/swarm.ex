defmodule MyspaceIpfs.Swarm do
  @moduledoc """
  MyspaceIpfs.Swarm is where the swarm commands of the IPFS API reside.
  """

  import MyspaceIpfs.Api
  import MyspaceIpfs.Utils

  @typep okresult :: MyspaceIpfs.okresult()
  @typep peer_id :: MyspaceIpfs.peer_id()

  @doc """
  List the addresses of known peers.
  """
  @spec addrs :: okresult
  def addrs do
    post_query("/swarm/addrs")
    |> okify()
  end

  @doc """
  List the interfaces swarm is listening on.
  """
  @spec addrs_listen :: okresult
  def addrs_listen do
    post_query("/swarm/addrs/listen")
    |> okify()
  end

  @doc """
  List the local addresses.
  """
  @spec addrs_local :: okresult
  def addrs_local do
    post_query("/swarm/addrs/local")
    |> okify()
  end

  @spec addrs_local(peer_id) :: okresult
  def addrs_local(peer_id) do
    post_query("/swarm/addrs/local?id=#{peer_id}")
    |> okify()
  end

  @doc """
  Open a connection to a given address.

  ## Parameters
  https://docs.ipfs.io/reference/http/api/#api-v0-swarm-connect
    `peer_id` - The address to connect to.
  """
  @spec connect(peer_id) :: okresult
  def connect(peer_id) do
    post_query("/swarm/connect?arg=#{peer_id}")
    |> okify()
  end

  @doc """
  Close a connection to a given address.

  ## Parameters
  https://docs.ipfs.io/reference/http/api/#api-v0-swarm-disconnect
    `peer_id` - The address to disconnect from.
  """
  @spec disconnect(peer_id) :: okresult
  def disconnect(peer_id) do
    post_query("/swarm/disconnect?arg=#{peer_id}")
    |> okify()
  end

  @doc """
  Manipulate address filters.
  """
  @spec filters :: okresult
  def filters() do
    post_query("/swarm/filters")
    |> okify()
  end

  @doc """
  Multiaddress filter to add.

  ## Parameters
  https://docs.ipfs.io/reference/http/api/#api-v0-swarm-filters-add
    `peer_id` - The multiaddress to add to the filter.
  """
  @spec filters_add(peer_id) :: okresult
  def filters_add(peer_id) do
    post_query("/swarm/filters/add?arg=#{peer_id}")
    |> okify()
  end

  @doc """
  Multiaddress filter to remove.

  ## Parameters
  https://docs.ipfs.io/reference/http/api/#api-v0-swarm-filters-rm
    `peer_id` - The multiaddress to remove from the filter.
  """
  @spec filters_rm(peer_id) :: okresult
  def filters_rm(peer_id) do
    post_query("/swarm/filters/rm?arg=#{peer_id}")
    |> okify()
  end

  @doc """
  Add peers to the peering service.

  ## Parameters
  https://docs.ipfs.io/reference/http/api/#api-v0-swarm-peering-add
    `peer_id` - The peer ID of the peer to add.
  """
  @spec peering_add(peer_id) :: okresult
  def peering_add(peer_id) do
    post_query("/swarm/peering/add?arg=#{peer_id}")
    |> okify()
  end

  @doc """
  List peers in the peering service.
  """
  @spec peering_ls :: okresult
  def peering_ls do
    post_query("/swarm/peering/ls")
    |> okify()
  end

  @doc """
  Remove peers from the peering service.

  ## Parameters
  https://docs.ipfs.io/reference/http/api/#api-v0-swarm-peering-rm
    `peer_id` - The multihash of the peer to remove.
  """
  def peering_rm(peer_id) do
    post_query("/swarm/peering/rm?arg=#{peer_id}")
    |> okify()
  end

  @doc """
  List peers with open connections.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-swarm-peers
    `verbose` - Write extra information.
    `streams` - Also list information about open streams for each connection.
    `latency` - Also list information about latency to each peer.
    `direction` - Also list information about direction of connection.
  """
  @spec peers :: okresult
  def peers do
    post_query("/swarm/peers")
    |> okify()
  end
end
