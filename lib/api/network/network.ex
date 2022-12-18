defmodule MyspaceIPFS.Api.Network do
  @moduledoc """
  MyspaceIPFS.Api.Bitswap is where the bootstrap commands of the IPFS API reside.
  """
  import MyspaceIPFS

  @doc """
  Show the id of the IPFS node.
  """
  @spec id :: any
  def id, do: post_query("/id")

  @doc """
  Ping a peer.
  """
  @spec ping(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def ping(id), do: post_query("/ping?arg=", id)
end
