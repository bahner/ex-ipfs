defmodule MyspaceIPFS.Multibase do
  @moduledoc """
  MyspaceIPFS.Multibase is where the multibase commands of the IPFS API reside.
  """

  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @typep okresult :: MyspaceIPFS.okresult()
  @typep opts :: MyspaceIPFS.opts()

  # Fixme add _file variants.
  @doc """
  Decode a multibase encoded string.

  ## Parameters
    `data` - File to decode.
  """
  @spec decode(binary) :: okresult
  def decode(binary) do
    with {:ok, file} <- write_temp_file(binary) do
      post_file("/multibase/decode", file)
      |> handle_plain_response()
      |> remove_temp_file(file)
    end
  end

  @doc """
  Encode a string to a multibase encoded string.

  ## Parameters
    `data` - File to encode.

  ## Options
    `b` - Multibase encoding to use.
  """
  @spec encode(binary, opts) :: okresult
  def encode(binary, opts \\ []) do
    with {:ok, file} <- write_temp_file(binary) do
      post_file("/multibase/encode", file, query: opts)
      |> handle_plain_response()
      |> remove_temp_file(file)
    end
  end

  @doc """
  List available multibase encodings.

  ## Options
    prefix - Only list encodings with the given prefix.
    numeric - Only list encodings with the given numeric code.
  """
  @spec list(opts) :: okresult
  def list(opts \\ []) do
    post_query("/multibase/list", query: opts)
    |> handle_json_response()
  end

  @doc """
  Transcode a multibase encoded string.

  ## Parameters
    `data` - Data to transcode.

  ## Options
    `b` - Multibase encoding to use
  """
  @spec transcode(binary, opts) :: okresult
  def transcode(binary, opts \\ []) do
    with {:ok, file} <- write_temp_file(binary) do
      post_file("/multibase/transcode", file, query: opts)
      |> handle_plain_response()
      |> remove_temp_file(file)
    end
  end
end
