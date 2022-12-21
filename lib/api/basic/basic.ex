defmodule MyspaceIPFS.Api.Basic do
  @moduledoc """
  MyspaceIPFS.Api is where the main commands of the IPFS API reside.

  #TODO:
    - Handle adding of directories.
    - Getting files from IPFS.
  """

  import MyspaceIPFS

  @type result :: MyspaceIPFS.result()
  @type opts :: MyspaceIPFS.opts()
  @type fspath :: MyspaceIPFS.fspath()
  @type path :: MyspaceIPFS.path()

  @doc """
  Add a file to IPFS. For options see the IPFS docs.
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-add
  """
  @spec add(fspath, opts) :: result
  def add(fspath, opts \\ []), do: post_file("/add", fspath, opts)

  # TODO: add get for output, archive, compress and compression level
  @doc """
  Get a file or directory from IPFS.
  As it stands ipfs sends a text blob back, so we need to implement a way to
  get the file extracted and saved to disk.

  For options see the IPFS docs.
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-get
  """
  @spec get(path, opts) :: result
  # def get(path, opts \\ []), do: post_query("/get?arg=" <> path, opts)
  def get(_, _ \\ []), do: {:error, "FIXME: Not implemented yet."}

  @doc """
  Get the contents of a file from ipfs.
  Easy way to get the contents of a text file for instance.

  For options see the IPFS docs.
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-cat
  """
  @spec cat(path, opts) :: result
  def cat(path, opts \\ []), do: post_query("/cat?arg=" <> path, opts)

  @doc """
    List the files in an IPFS object.
  """
  @spec ls(path, opts) :: result
  def ls(path, opts \\ []), do: post_query("/ls?arg=" <> path, opts)
end
