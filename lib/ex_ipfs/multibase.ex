defmodule ExIpfs.Multibase do
  @moduledoc """
  ExIpfs.Multibase is where the multibase commands of the IPFS API reside.
  """

  import ExIpfs.Api
  import ExIpfs.Utils
  alias ExIpfs.MultibaseCodec

  @typedoc """
  A multibase codec.
  """
  @type codec :: %ExIpfs.MultibaseCodec{
          name: binary(),
          code: non_neg_integer(),
          prefix: binary(),
          description: binary()
        }
  @typedoc """
  A multibase encoding.
  """
  @type encoding :: %ExIpfs.MultibaseEncoding{
          name: binary,
          code: non_neg_integer()
        }

  @doc """
  Decode a multibase encoded string.

  ## Parameters
    `data` - Data to decode.
  """
  @spec decode!(binary) :: any | ExIpfs.Api.error_response()
  def decode!(data) when is_binary(data) do
    multipart_content(data)
    |> post_multipart("/multibase/decode")
  end

  @spec decode(binary) :: {:ok, binary()} | ExIpfs.Api.error_response()
  def decode(data) when is_binary(data) do
    decode!(data)
    |> okify()
  end

  @spec decode(list) :: {:ok, list} | ExIpfs.Api.error_response()
  def decode(data) when is_list(data) do
    Enum.map(data, &decode!/1)
    |> okify()
  end

  @doc """
  Encode a string to a multibase encoded string.

  ## Parameters
    `data` - File to encode.

  ## Options
    `b` - Multibase encoding to use.
  """
  @spec encode!(binary, list) :: binary() | ExIpfs.Api.error_response()
  def encode!(data, opts) when is_binary(data) do
    multipart_content(data)
    |> post_multipart("/multibase/encode", query: opts)
  end

  @spec encode(binary, list) :: {:ok, binary()} | ExIpfs.Api.error_response()
  def encode(data, opts \\ [])

  def encode(data, opts) when is_list(data) do
    Enum.map(data, &encode!(&1, opts))
    |> okify()
  end

  def encode(data, opts) when is_binary(data) do
    encode!(data, opts)
    |> okify()
  end

  @doc """
  List available multibase encodings.

  ## Options
    prefix - Only list encodings with the given prefix.
    numeric - Only list encodings with the given numeric code.
  """
  @spec list(list()) ::
          {:ok, [codec()]} | ExIpfs.Api.error_response()
  def list(opts \\ []) do
    post_query("/multibase/list", query: opts)
    |> filter_empties()
    |> Enum.map(&MultibaseCodec.new/1)
    |> okify()
  end

  @doc """
  Transcode a multibase encoded string.

  ## Parameters
    `data` - Data to transcode.

  ## Options
    `b` - Multibase encoding to use
  """
  @spec transcode(binary, list()) :: {:ok, any} | ExIpfs.Api.error_response()
  def transcode(data, opts \\ []) do
    multipart_content(data)
    |> post_multipart("/multibase/transcode", query: opts)
    # FIXME: type goes here. Check it out.
    |> okify()
  end
end
