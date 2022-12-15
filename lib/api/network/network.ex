defmodule MyspaceIPFS.Api.Network do
  @moduledoc """
  MyspaceIPFS.Api.Bitswap is where the bootstrap commands of the IPFS API reside.
  """
  import MyspaceIPFS.Utils

  @doc """
  Show the id of the IPFS node.
  """
  @spec id :: any
  def id, do: request_get("/id")

  @doc """
  Ping a peer.
  """
  @spec ping(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def ping(id), do: request_get("/ping?arg=", id)
end
