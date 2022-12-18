defmodule MyspaceIPFS.Api.Advanced.Stats do
  @moduledoc """
  MyspaceIPFS.Api.Stats is where the stats commands of the IPFS API reside.
  """
  import MyspaceIPFS

  @spec bitswap ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def bitswap, do: post_query("/stats/bitswap")

  @spec bw ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def bw, do: post_query("/stats/bw")

  @spec dht :: {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def dht, do: post_query("/stats/dht")

  # FIXME: bw_peer is not implemented yet.
  # @spec bw_peer(binary, ) :: any
  # def bw, do: post_query("/stats/bw")

  @spec provide ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def provide, do: post_query("/stats/provide")

  @spec repo :: any
  def repo, do: post_query("/stats/repo")
end
