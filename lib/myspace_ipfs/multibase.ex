defmodule MyspaceIPFS.Multibase do
  @moduledoc """
  MyspaceIPFS.Multibase is where the multibase commands of the IPFS API reside.
  """

  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils
  alias MyspaceIPFS.MultibaseCodec

  @typedoc """
  A multibase codec.

  ```
  %MyspaceIPFS.MultibaseCodec{
    name: binary(),
    code: non_neg_integer(),
    prefix: binary(),
    description: binary()


  }
  ```
  """
  @type codec :: MyspaceIPFS.MultibaseCodec.t()

  @typedoc """
  A multibase encoding.

  ```
  %MyspaceIPFS.MultibaseEncoding{
    name: binary(),
    code: non_neg_integer()
  }
  ```
  """
  @type encoding :: MyspaceIPFS.MultibaseEncoding.t()

  @doc """
  Decode a multibase encoded string.

  ## Parameters
    `data` - Data to decode.
  """
  @spec decode(binary) :: {:ok, any} | MyspaceIPFS.Api.api_error()
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
  @spec decode!(binary) :: any | MyspaceIPFS.Api.api_error()
  def decode!(data) do
    multipart_content(data)
    |> post_multipart("/multibase/decode")
  end

  @doc """
  Decode a multibase encoded file.

  ## Parameters
    `data` - File to decode.
  """
  @spec decode_file(MyspaceIPFS.fspath()) :: {:ok, any} | MyspaceIPFS.Api.api_error()
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
  @spec encode(binary, MyspaceIPFS.opts()) :: {:ok, any} | MyspaceIPFS.Api.api_error()
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
  @spec list(MyspaceIPFS.opts()) ::
          {:ok, [codec()]} | MyspaceIPFS.Api.api_error()
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
  @spec transcode(binary, MyspaceIPFS.opts()) :: {:ok, any} | MyspaceIPFS.Api.api_error()
  def transcode(data, opts \\ []) do
    multipart_content(data)
    |> post_multipart("/multibase/transcode", query: opts)
    #FIXME: type goes here. Check it out.
    |> okify()
  end
end
