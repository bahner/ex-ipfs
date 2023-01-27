defmodule MyspaceIpfs.Cid do
  @moduledoc """
  MyspaceIpfs.Cid is where the cid commands of the IPFS API reside.
  """
  import MyspaceIpfs.Api
  import MyspaceIpfs.Utils
  alias MyspaceIpfs.MultiCodec
  alias MyspaceIpfs.MultiHash
  alias MyspaceIpfs.MultibaseEncoding
  alias MyspaceIpfs.MultiCodec
  alias MyspaceIpfs.CidCid

  @typep okmapped :: MySpaceIPFS.okmapped()
  @typep opts :: MySpaceIPFS.opts()
  @typep cid :: MySpaceIPFS.cid()

  @doc """
  Convert to base32 CID version 1.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-cid-base32
  `cid` - The CID to convert to base32.
  """

  @spec base32(binary) :: okmapped()
  def base32(cid),
    do:
      post_query("/cid/base32?arg=" <> cid)
      |> handle_api_response()
      |> snake_atomize()
      |> CidCid.new()
      |> okify()

  @doc """
  List available multibase encodings.

  """
  @spec bases(opts) :: okmapped()
  def bases(opts \\ []),
    do:
      post_query("/cid/bases", query: opts)
      |> handle_api_response()
      |> snake_atomize()
      |> Enum.map(&MultibaseEncoding.new/1)
      |> okify()

  @doc """
  List available CID codecs.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-cid-codecs

  `numeric` <bool> - Show codec numeric code.
  `supported` <bool> - Show only supported codecs.
  """
  @spec codecs(opts) :: {:ok, [MultibaseCodec.t()]} | {:error, any()}
  def codecs(opts \\ []),
    do:
      post_query("/cid/codecs", query: opts)
      |> handle_api_response()
      |> snake_atomize()
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
  @spec format(cid, opts) :: okmapped()
  def format(cid, opts \\ []),
    do:
      post_query("/cid/format?arg=" <> cid, query: opts)
      |> handle_api_response()
      |> snake_atomize()
      |> CidCid.new()
      |> okify()

  @doc """
  List available multihashes.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-cid-hashes

  `supported` <bool> - Show only supported hashes.
  """
  @spec hashes(opts) :: okmapped()
  def hashes(opts \\ []),
    do:
      post_query("/cid/hashes", query: opts)
      |> handle_api_response()
      |> snake_atomize()
      |> Enum.map(&MultiHash.new/1)
      |> okify()
end
