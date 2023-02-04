defmodule MyspaceIPFS.Cid do
  @moduledoc """
  MyspaceIPFS.Cid is where the cid commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils
  alias MyspaceIPFS.MultiCodec
  alias MyspaceIPFS.MultiHash
  alias MyspaceIPFS.MultibaseEncoding
  alias MyspaceIPFS.MultiCodec
  alias MyspaceIPFS.CidCid

  @typep opts :: MyspaceIPFS.opts()
  @typep cid :: MyspaceIPFS.cid()
  @typep api_error :: MyspaceIPFS.Api.api_error()
  @type multibase_codec :: MyspaceIPFS.MultibaseCodec.t()

  @doc """
  Convert to base32 CID version 1.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-cid-base32
  `cid` - The CID to convert to base32.
  """

  @spec base32(binary) :: {:ok, any} | api_error
  def base32(cid),
    do:
      post_query("/cid/base32?arg=" <> cid)
      |> CidCid.new()
      |> okify()

  @doc """
  List available multibase encodings.

  """
  @spec bases(opts) :: {:ok, any} | api_error
  def bases(opts \\ []),
    do:
      post_query("/cid/bases", query: opts)
      |> Enum.map(&MultibaseEncoding.new/1)
      |> okify()

  @doc """
  List available CID codecs.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-cid-codecs

  `numeric` <bool> - Show codec numeric code.
  `supported` <bool> - Show only supported codecs.
  """
  @spec codecs(opts) :: {:ok, [multibase_codec]} | api_error
  def codecs(opts \\ []),
    do:
      post_query("/cid/codecs", query: opts)
      |> Enum.map(&snake_atomize/1)
      |> Enum.map(&MultiCodec.new/1)
      |> okify()

  @doc """
  Format and convert a CID in various useful ways.

  ## Parameters
  `cid` - The CID to format and convert.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-cid-format
  `f` <string> - printf style format string. Default: `%s`.
  `v` <string> - CID version.
  `b` <string> - Multibase to display CID in.
  `mc` <string> - Multicodec.
  """
  @spec format(cid, opts) :: {:ok, any} | api_error
  def format(cid, opts \\ []),
    do:
      post_query("/cid/format?arg=" <> cid, query: opts)
      |> CidCid.new()
      |> okify()

  @doc """
  List available multihashes.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-cid-hashes

  `supported` <bool> - Show only supported hashes.
  """
  @spec hashes(opts) :: {:ok, any} | api_error
  def hashes(opts \\ []),
    do:
      post_query("/cid/hashes", query: opts)
      |> Enum.map(&snake_atomize/1)
      |> Enum.map(&MultiHash.new/1)
      |> okify()
end
