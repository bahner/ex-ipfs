defmodule MyspaceIPFS.Block do
  @moduledoc """
  MyspaceIPFS.Block is where the block commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @typep okmapped :: MySpaceIPFS.okmapped()
  @typep opts :: MySpaceIPFS.opts()
  @typep cid :: MySpaceIPFS.cid()
  @typep fspath :: MySpaceIPFS.fspath()

  @doc """
  Get a raw IPFS block.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-block-get
  `cid` - The CID of the block to get.
  """
  @spec get(cid) :: okmapped()
  def get(cid) do
    post_query("/block/get?arg=" <> cid)
    |> handle_api_response()
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
  @spec put(fspath, opts) :: okmapped
  def put(fspath, opts \\ []) do
    multipart(fspath)
    |> post_multipart("/block/put", query: opts)
    |> handle_api_response()
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
  @spec rm(cid) :: okmapped()
  def rm(cid) do
    post_query("/block/rm?arg=" <> cid)
    |> handle_api_response()
    |> okify()
  end

  @doc """
  Get block stat.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-block-stat
  `cid` - The CID of the block to stat.
  """
  @spec stat(cid) :: okmapped()
  def stat(cid) do
    post_query("/block/stat?arg=" <> cid)
    |> handle_api_response()
    |> okify()
  end
end
