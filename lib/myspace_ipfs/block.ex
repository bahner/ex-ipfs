defmodule MyspaceIpfs.Block do
  @moduledoc """
  MyspaceIpfs.Block is where the block commands of the IPFS API reside.
  """
  import MyspaceIpfs.Api
  import MyspaceIpfs.Utils
  alias MyspaceIpfs.ErrorHash
  alias MyspaceIpfs.KeySize

  @type api_error :: MyspaceIpfs.Api.api_error()
  @typep opts :: MyspaceIpfs.opts()
  @typep cid :: MyspaceIpfs.cid()
  @typep fspath :: MyspaceIpfs.fspath()

  @doc """
  Get a raw IPFS block.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-block-get
  `cid` - The CID of the block to get.
  """
  @spec get(cid) :: {:ok, any} | api_error()
  def get(cid) do
    post_query("/block/get?arg=" <> cid)
    |> okify()
  end

  @doc """
  Put file as an IPFS block.

  ## Parameters
  `data` - The data to be stored as a block.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-block-put
  ```
  [
    `cid-codec`: <string>, # CID codec to use.
    `mhtype`: <string>, # Hash function to use.
    `mhlen`: <int>, # Hash length.
    `pin`: <bool>, # Pin added blocks recursively.
    `allow-big-block`: <bool>, # Allow blocks larger than 1MiB.
  ]
  ```
  """
  @spec put(any, opts) :: {:ok, any} | api_error()
  def put(data, opts \\ []) do
    multipart_content(data)
    |> post_multipart("/block/put", query: opts)
    |> snake_atomize()
    |> KeySize.new()
    |> okify()
  end

  @doc """
  Put file as an IPFS block.

  ## Parameters
  `fspath` - The path to the file to be stored as a block.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-block-put
  ```
  [
    `cid-codec`: <string>, # CID codec to use.
    `mhtype`: <string>, # Hash function to use.
    `mhlen`: <int>, # Hash length.
    `pin`: <bool>, # Pin added blocks recursively.
    `allow-big-block`: <bool>, # Allow blocks larger than 1MiB.
  ]
  ```
  """
  @spec put_file(fspath, opts) :: {:ok, any} | api_error()
  def put_file(file, opts \\ []) do
    multipart(file)
    |> post_multipart("/block/put", query: opts)
    |> snake_atomize()
    |> KeySize.new()
    |> okify()
  end

  @doc """
  Remove a block from the blockstore.

  ## Parameters
  `cid` - The CID of the block to remove.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-block-rm
  ```
  [
    `force`: <bool>, # Ignore nonexistent blocks.
    `quiet`: <bool>, # Write minimal output.
  ]
  ```
  """
  @spec rm(cid) :: {:ok, any} | api_error()
  def rm(cid) do
    post_query("/block/rm?arg=" <> cid)
    |> snake_atomize()
    |> ErrorHash.new()
    |> okify()
  end

  @doc """
  Get block stat.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-block-stat
  `cid` - The CID of the block to stat.
  """
  @spec stat(cid) :: {:ok, any} | api_error()
  def stat(cid) do
    post_query("/block/stat?arg=" <> cid)
    |> snake_atomize()
    |> KeySize.new()
    |> okify()
  end
end
