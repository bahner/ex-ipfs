defmodule MyspaceIPFS.Api.Swarm do
  @moduledoc """
  MyspaceIPFS.Api.Swarm is where the swarm commands of the IPFS API reside.
  """

  import MyspaceIPFS.Utils

  @spec peers :: {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def peers, do: request_get("/swarm/peers")

  @spec addrs :: {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def addrs, do: request_get("/swarm/addrs")

  @spec addrs_listen :: {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def addrs_listen, do: request_get("/swarm/addrs/listen")

  @spec addrs_local ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def addrs_local, do: request_get("/swarm/addrs/local")

  @spec connect(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def connect(multihash), do: request_get("/swarm/connect?arg=", multihash)

    @spec disconnect(binary) ::
            {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
    def disconnect(multihash) when is_bitstring(multihash),
      do: request_get("/swarm/disconnect?arg=", multihash)

  @spec filters ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def filters(), do: request_get("/swarm/filters")

  @spec filters_add(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def filters_add(multihash), do: request_get("/swarm/filters/add?arg=", multihash)

  @spec filters_rm(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def filters_rm(multihash), do: request_get("/swarm/filters/rm?arg=", multihash)
end
