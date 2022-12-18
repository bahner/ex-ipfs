defmodule MyspaceIPFS.Api.Basic do
  @moduledoc """
  MyspaceIPFS.Api is where the main commands of the IPFS API reside.
  """

  import MyspaceIPFS

  @doc """
  Add a file to IPFS.
  """
  @spec add(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def add(path), do: post_file("/add", path)

  # TODO: add get for output, archive, compress and compression level
  @doc """
  Get a file or directory from IPFS.
  """
  @spec get(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def get(multihash) when is_bitstring(multihash), do: post_query("/get?arg=", multihash)

  @doc """
  Get the contents of a file from ipfs.
  Easy way to get the contents of a text file for instance.
  """
  @spec cat(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def cat(multihash) when is_bitstring(multihash), do: post_query("/cat?arg=", multihash)

  # TODO:  Implement proper Json Format.
  @doc """
    List the files in an IPFS object.
  """
  @spec ls(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def ls(multihash) when is_bitstring(multihash), do: post_query("/ls?arg=", multihash)

  @doc """
  Init a new repo. Required if you want to use IPFS as a library.
  """
  @spec init :: {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def init do
    post_query("/init")
  end
end
