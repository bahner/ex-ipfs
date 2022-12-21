defmodule MyspaceIPFS.Api.Advanced do
  @moduledoc """
  MyspaceIPFS.Api is where the key commands of the IPFS API reside.
  """
  import MyspaceIPFS

  @type result :: MyspaceIPFS.result()
  @type opts :: MyspaceIPFS.opts()
  @type path :: MyspaceIPFS.path()

  @experimental Application.get_env(:myspace_ipfs, :experimental)

  @doc """
  Shutdown the IPFS daemon.
  """
  @spec shutdown :: result
  def shutdown, do: post_query("/shutdown")

  @doc """
  Instruct daemon to mount IPFS and IPNS to the filesystem (read-only).

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-mount
  Example of options:
  ```
  [
    ipfs-path: "/ipfs",
    ipns-path: "/ipns"
  ]
  ```
  """
  def mount(opts \\ []) do
    case @experimental do
      true -> post_query("/mount", opts)
      false -> raise "This command is experimental and must be enabled in the config."
    end
  end

  @doc """
  Resolve the value of names to IPFS.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-resolve
  Example of options:
  ```
  [
    recursive: true,
    nocache: true,
    dht-record-count: 10,
    dht-timeout: 10
  ]
  ```
  """
  @spec resolve(path, opts) :: result
  def resolve(path, opts \\ []), do: post_query("/resolve?arg=" <> path, opts)
end
