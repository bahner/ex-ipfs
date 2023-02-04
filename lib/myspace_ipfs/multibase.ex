defmodule MyspaceIPFS.Multibase do
  @moduledoc """
  MyspaceIPFS.Multibase is where the multibase commands of the IPFS API reside.
  """

  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils
  alias MyspaceIPFS.MultibaseCodec

  @typep api_error :: MyspaceIPFS.Api.api_error()
  @typep opts :: MyspaceIPFS.opts()

  @doc """
  Decode a multibase encoded string.

  ## Parameters
    `data` - Data to decode.
  """
  @spec decode(binary) :: {:ok, any} | api_error()
  def decode(data) do
    multipart_content(data)
    |> post_multipart("/multibase/decode")
    |> okify()
  end

  @doc """
  Decode a multibase encoded string.

  ## Parameters
    `data` - Data to decode.
  """
  @spec decode!(binary) :: any | api_error()
  def decode!(data) do
    multipart_content(data)
    |> post_multipart("/multibase/decode")
  end

  @doc """
  Decode a multibase encoded file.

  ## Parameters
    `data` - File to decode.
  """
  @spec decode_file(Path.t()) :: {:ok, any} | api_error()
  def decode_file(data) do
    multipart_content(data)
    |> post_multipart("/multibase/decode")
    |> okify()
  end

  @doc """
  Encode a string to a multibase encoded string.

  ## Parameters
    `data` - File to encode.

  ## Options
    `b` - Multibase encoding to use.
  """
  @spec encode(binary, opts) :: {:ok, any} | api_error()
  def encode(data, opts \\ []) do
    multipart_content(data)
    |> post_multipart("/multibase/encode", query: opts)
    |> okify()
  end

  @doc """
  List available multibase encodings.

  ## Options
    prefix - Only list encodings with the given prefix.
    numeric - Only list encodings with the given numeric code.
  """
  @spec list(opts) :: {:ok, any} | api_error()
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
  @spec transcode(binary, opts) :: {:ok, any} | api_error()
  def transcode(data, opts \\ []) do
    multipart_content(data)
    |> post_multipart("/multibase/transcode", query: opts)
    |> okify()
  end
end
