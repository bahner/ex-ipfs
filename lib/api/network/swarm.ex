defmodule MyspaceIPFS.Api.Network.Swarm do
  @moduledoc """
  MyspaceIPFS.Api.Swarm is where the swarm commands of the IPFS API reside.
  """

  import MyspaceIPFS

  @spec peers :: {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def peers, do: post_query("/swarm/peers")

  @spec addrs :: {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def addrs, do: post_query("/swarm/addrs")

  @spec addrs_listen ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def addrs_listen, do: post_query("/swarm/addrs/listen")

  @spec addrs_local ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def addrs_local, do: post_query("/swarm/addrs/local")

  @spec connect(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def connect(multihash), do: post_query("/swarm/connect?arg=", multihash)

  @spec disconnect(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def disconnect(multihash) when is_bitstring(multihash),
    do: post_query("/swarm/disconnect?arg=", multihash)

  @spec filters ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def filters(), do: post_query("/swarm/filters")

  @spec filters_add(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def filters_add(multihash), do: post_query("/swarm/filters/add?arg=", multihash)

  @spec filters_rm(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def filters_rm(multihash), do: post_query("/swarm/filters/rm?arg=", multihash)
end
