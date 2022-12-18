defmodule MyspaceIPFS.Api.Basic do
  @moduledoc """
  MyspaceIPFS.Api is where the main commands of the IPFS API reside.
  """

  import MyspaceIPFS

  @doc """
  Add a file to IPFS.
  """
  def add(path), do: post_file("/add", path)

  # TODO: add get for output, archive, compress and compression level
  @doc """
  Get a file or directory from IPFS.
  """
  def get(multihash) when is_bitstring(multihash), do: post_query("/get?arg=" <> multihash)

  @doc """
  Get the contents of a file from ipfs.
  Easy way to get the contents of a text file for instance.
  """
  def cat(multihash) when is_bitstring(multihash), do: post_query("/cat?arg=" <> multihash)

  # TODO:  Implement proper Json Format.
  @doc """
    List the files in an IPFS object.
  """
  def ls(multihash) when is_bitstring(multihash), do: post_query("/ls?arg=" <> multihash)

  @doc """
  Init a new repo. Required if you want to use IPFS as a library.
  """
  def init do
    post_query("/init")
  end
end
