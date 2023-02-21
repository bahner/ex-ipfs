defmodule ExIPFS.Block do
  @moduledoc """
  ExIPFS.Block is where the block commands of the IPFS API reside.
  """

  import ExIPFS.Api
  import ExIPFS.Utils

  alias ExIPFS.BlockErrorHash
  alias ExIPFS.BlockKeySize

  @typedoc """
  A structure from the API that is an error and its hash.
  """
  @type error_hash :: %ExIPFS.BlockErrorHash{error: binary, hash: binary}

  @typedoc """
  A structure from the API that is a key and its size.
  """
  @type key_size :: %ExIPFS.BlockKeySize{key: binary, size: non_neg_integer}

  @doc """
  Get a raw IPFS block.

  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-block-get

  ## Parameters
  `cid` - The CID of the block to get.
  """
  @spec get(binary) :: {:ok, bitstring()} | ExIPFS.Api.error_response()
  def get(cid) do
    post_query("/block/get?arg=" <> cid)
    |> okify()
  end

  @doc """
  Put data as an IPFS block.

  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-block-put

  ## Parameters
  `data` - The data to be stored as a block.

  ## Options
  ```
  [
    'cid-codec': <string>, # CID codec to use.
    'mhtype': <string>, # Hash function to use.
    'mhlen': <int>, # Hash length.
    'pin': <bool>, # Pin added blocks recursively.
    'allow-big-block': <bool>, # Allow blocks larger than 1MiB.
  ]
  ```
  """
  @spec put(any, list) :: {:ok, key_size()} | ExIPFS.Api.error_response()
  def put(data, opts \\ []) do
    multipart_content(data)
    |> post_multipart("/block/put", query: opts)
    |> BlockKeySize.new()
    |> okify()
  end

  @doc """
  Put file as an IPFS block.

  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-block-put

  ## Parameters
  `fspath` - The path to the file to be stored as a block.

  ## Options
  ```
  [
    'cid-codec': <string>, # CID codec to use.
    'mhtype': <string>, # Hash function to use.
    'mhlen': <int>, # Hash length.
    'pin': <bool>, # Pin added blocks recursively.
    'allow-big-block': <bool>, # Allow blocks larger than 1MiB.
  ]
  ```
  """
  @spec put_file(Path.t(), list) :: {:ok, key_size()} | ExIPFS.Api.error_response()
  def put_file(file, opts \\ []) do
    multipart(file)
    |> post_multipart("/block/put", query: opts)
    |> BlockKeySize.new()
    |> okify()
  end

  @doc """
  Remove a block from the blockstore.

  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-block-rm

  ## Parameters
  `cid` - The CID of the block to remove.

  ## Options
  ```
  [
    'force': <bool>, # Ignore nonexistent blocks.
    'quiet': <bool>, # Write minimal output.
  ]
  ```
  """
  @spec rm(binary()) :: {:ok, error_hash()} | ExIPFS.Api.error_response()
  def rm(cid) do
    post_query("/block/rm?arg=" <> cid)
    |> BlockErrorHash.new()
    |> okify()
  end

  @doc """
  Get block stat.

  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-block-stat

  ## Parameters
  `cid` - The CID of the block to stat.
  """
  @spec stat(binary()) :: {:ok, key_size()} | ExIPFS.Api.error_response()
  def stat(cid) do
    post_query("/block/stat?arg=" <> cid)
    |> BlockKeySize.new()
    |> okify()
  end
end
