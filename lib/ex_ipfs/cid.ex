defmodule ExIpfs.Cid do
  @moduledoc """
  ExIpfs.Cid is where the cid commands of the IPFS API reside.
  """
  import ExIpfs.Api
  import ExIpfs.Utils
  alias ExIpfs.CidBase32CID
  alias ExIpfs.MultibaseEncoding
  alias ExIpfs.Multicodec
  alias ExIpfs.Multihash

  @typedoc """
  A v1 CID. This is the new Base32 CID format, which is likely to last and is preferred.
  """
  @type base32cid :: %ExIpfs.CidBase32CID{
          cid_str: binary,
          formatted: binary,
          error_msg: binary
        }

  @doc """
  Convert to base32 CID version 1.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-cid-base32
  `cid` - The CID to convert to base32.
  """

  @spec base32(binary()) :: {:ok, base32cid()} | ExIpfs.Api.error_response()
  def base32(cid),
    do:
      post_query("/cid/base32?arg=" <> cid)
      |> CidBase32CID.new()
      |> okify()

  @doc """
  List available multibase encodings.

  """
  @spec bases() :: {:ok, list} | ExIpfs.Api.error_response()
  @spec bases(list()) :: {:ok, list} | ExIpfs.Api.error_response()
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
  @spec codecs() :: {:ok, [ExIpfs.multi_codec()]} | ExIpfs.Api.error_response()
  @spec codecs(list()) :: {:ok, [ExIpfs.multi_codec()]} | ExIpfs.Api.error_response()
  def codecs(opts \\ []),
    do:
      post_query("/cid/codecs", query: opts)
      |> Enum.map(&Multicodec.new/1)
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
  @spec format(binary()) :: {:ok, any} | ExIpfs.Api.error_response()
  @spec format(binary(), list()) :: {:ok, any} | ExIpfs.Api.error_response()
  def format(cid, opts \\ []),
    do:
      post_query("/cid/format?arg=" <> cid, query: opts)
      |> CidBase32CID.new()
      |> okify()

  @doc """
  List available Multihashes.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-cid-hashes

  `supported` <bool> - Show only supported hashes.
  """
  @spec hashes() :: {:ok, ExIpfs.multi_hash()} | ExIpfs.Api.error_response()
  @spec hashes(list()) :: {:ok, ExIpfs.multi_hash()} | ExIpfs.Api.error_response()
  def hashes(opts \\ []),
    do:
      post_query("/cid/hashes", query: opts)
      |> Enum.map(&Multihash.new/1)
      |> okify()
end
