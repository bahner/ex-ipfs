defmodule MyspaceIPFS.Api.Advanced do
  @moduledoc """
  MyspaceIPFS.Api is where the key commands of the IPFS API reside.
  """
  import MyspaceIPFS.Utils

  @doc """
  Shutdown the IPFS daemon.
  """
  @spec shutdown :: any
  def shutdown, do: request_get("/shutdown")

  @doc """
  Mounts IPFS and IPNS to the filesystem (read-only).

  Takes paths to mount IPFS and IPNS to as arguments.
  """
  @spec mount(binary, binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def mount(ipfs \\ "/ipfs", ipns \\ "/ipns"),
    do: request_get("/mount?ipfs-path=#{ipfs}&ipns-path=#{ipns}")

  @spec resolve(binary) :: any
  def resolve(multihash), do: request_get("/resolve?arg=", multihash)
end
