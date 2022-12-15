defmodule MyspaceIPFS.Api.Advanced.Stats do
  @moduledoc """
  MyspaceIPFS.Api.Stats is where the stats commands of the IPFS API reside.
  """
  import MyspaceIPFS.Utils

  @spec bitswap ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def bitswap, do: request_get("/stats/bitswap")

  @spec bw ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def bw, do: request_get("/stats/bw")

  @spec dht :: {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def dht, do: request_get("/stats/dht")

  # FIXME: bw_peer is not implemented yet.
  # @spec bw_peer(binary, ) :: any
  # def bw, do: request_get("/stats/bw")

  @spec provide ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def provide, do: request_get("/stats/provide")

  @spec repo :: any
  def repo, do: request_get("/stats/repo")
end
