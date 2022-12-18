defmodule MyspaceIPFS.Api.Network.Bitswap do
  @moduledoc """
  MyspaceIPFS.Api.Bitswap is where the bootstrap commands of the IPFS API reside.
  """
  import MyspaceIPFS

  @doc """
  Get the current bitswap ledger for a given peer.
  """
  @spec ledger(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def ledger(peer_id), do: post_query("/bitswap/ledger?arg=", peer_id)

  @doc """
  Get the current bitswap stats.
  """
  @spec stat(boolean, boolean) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def stat(verbose \\ false, human \\ false),
    do:
      post_query(
        "/bitswap/stat?" <>
          "verbose=" <> to_string(verbose) <> "&" <> "human=" <> to_string(human)
      )

  @doc """
  Reprovide blocks to the network.
  """
  @spec reprovide ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def reprovide, do: post_query("/bitswap/reprovide")

  @doc """
  Get the current bitswap wantlist.
  """
  @spec wantlist(any) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def wantlist(peer \\ "") do
    if peer != "" do
      post_query("/bitswap/wantlist?peer", peer)
    else
      post_query("/bitswap/wantlist")
    end
  end
end
