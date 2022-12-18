defmodule MyspaceIPFS.Api.Advanced do
  @moduledoc """
  MyspaceIPFS.Api is where the key commands of the IPFS API reside.
  """
  import MyspaceIPFS

  @doc """
  Shutdown the IPFS daemon.
  """
  def shutdown, do: post_query("/shutdown")

  @doc """
  Mounts IPFS and IPNS to the filesystem (read-only).

  Takes paths to mount IPFS and IPNS to as arguments.
  """
  def mount(ipfs \\ "/ipfs", ipns \\ "/ipns"),
    do: post_query("/mount?ipfs-path=#{ipfs}&ipns-path=#{ipns}")

  def resolve(multihash), do: post_query("/resolve?arg=" <> multihash)
end
