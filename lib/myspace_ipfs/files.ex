defmodule MyspaceIpfs.Files do
  @moduledoc """
  MyspaceIpfs.Files is where the files commands of the IPFS API reside.
  """
  import MyspaceIpfs.Api
  import MyspaceIpfs.Utils

  @typep api_error :: MyspaceIpfs.Api.api_error()
  @typep opts :: MyspaceIpfs.opts()
  @typep path :: MyspaceIpfs.path()
  @typep fspath :: MyspaceIpfs.fspath()

  @doc """
  Copy files into mfs.

  ## Parameters
  source: The source file to copy.
  dest: The destination path for the file to be copied to.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-files-cp
  ```
  [
    parents: <bool>, # Make parent directories as needed.
  ]
  ```
  """
  # FIXME: verify return type
  @spec cp(fspath, fspath, opts) :: {:ok, any} | api_error()
  def cp(source, dest, opts \\ []) do
    post_query("/files/cp?arg=" <> source <> "&arg=" <> dest, query: opts)
    |> okify()
  end

  @doc """
  Change the CID version or hash function of a path's root node.

  ## Parameters
  path: The path to change the CID for, if doubt use "/"

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-files-chcid
  ```
  [
    cid-version: <int>, # CID version. (experimental)
    hash: <string>, # Hash function to use. Implies CID version 1 if used. (experimental)
  ]
  ```
  """
  # FIXME: verify return type
  @spec chcid(path, opts) :: {:ok, any} | api_error()
  def chcid(path, opts \\ []) do
    post_query("/files/chcid?arg=" <> path, query: opts)
    |> okify()
  end

  @doc """
  Flush a given path's data to disk.

  ## Parameters
  https://docs.ipfs.io/reference/http/api/#api-v0-files-flush
  `path` - The path to flush. If not specified, the entire repo will be flushed.
  """
  # FIXME: verify return type
  @spec flush() :: {:ok, any} | api_error()
  def flush() do
    post_query("/files/flush")
    |> okify()
  end

  @spec flush(path) :: {:ok, any} | api_error()
  def flush(path) do
    post_query("/files/flush?arg=" <> path)
    |> okify()
  end

  @doc """
  List directories in the local mutable namespace.

  ## Parameters
  `path` - The path to list. If in doubt, use "/".

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-files-ls
  ```
  [
    l: <bool>, # Use long listing format.
    U: <bool>, # Do not sort; list entries in directory order.
  ]
  ```
  """
  @spec ls(path, opts) :: {:ok, any} | api_error()
  def ls(path, opts \\ []) do
    post_query("/files/ls?arg=" <> path, query: opts)
    |> okify()
  end

  @doc """
  Make directories.

  ## Parameters
  `path` - The path to make directories at.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-files-mkdir
  ```
  [
    `parents` - <bool>, # No error if existing, make parent directories as needed.
    `hash` - <string>, # Hash function to use. Implies CID version 1 if used. (experimental)
    `cid-version` - <int>, # CID version. (experimental)
  ]
  ```
  """
  @spec mkdir(path, opts) :: {:ok, any} | api_error()
  def mkdir(path, opts \\ []) do
    post_query("/files/mkdir?arg=" <> path, query: opts)
    |> okify()
  end

  @doc """
  Move files.

  ## Parameters
  `source` - The source file to move.
  `dest` - The destination path for the file to be moved to.
  """
  @spec mv(path, path) :: {:ok, any} | api_error()
  def mv(source, dest) do
    post_query("/files/mv?arg=" <> source <> "&arg=" <> dest)
    |> okify()
  end

  @doc """
  Read a file in a given mfs.

  ## Parameters
  `path` - The path to the file to be read.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-files-read
  ```
  [
    offset: <int>, # Byte offset to begin reading from.
    count: <int>, # Maximum number of bytes to read.
  ]
  ```
  """
  @spec read(path, opts) :: {:ok, any} | api_error()
  def read(path, opts \\ []) do
    post_query("/files/read?arg=" <> path, query: opts)
    |> okify()
  end

  @doc """
  Remove a file from mfs.

  ## Parameters
  `path` - The path to the file to be removed.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-files-rm
  ```
  [
    recursive: <bool>, # Recursively remove directories.
    force: <bool>, # Forcibly remove target at path; implies recursive for directories.
  ]
  ```
  """
  @spec rm(path, opts) :: {:ok, any} | api_error()
  def rm(path, opts \\ []) do
    post_query("/files/rm?arg=" <> path, query: opts)
    |> okify()
  end

  @doc """
  Get file status.

  ## Parameters
  `path` - The path to the file to stat.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-files-stat
  ```
  [
    format: <string>, # Format to print out.
                      Allowed tokens:
                      <hash> <size> <cumulsize> <type> <childs>
    hash: <bool>, # Compute the hash of the file.
    size: <bool>, # Compute the size of the file.
    with-local: <bool>, # Compute the size of the file including the local repo.
  ]
  ```
  """
  @spec stat(path, opts) :: {:ok, any} | api_error()
  def stat(path, opts \\ []) do
    post_query("/files/stat?arg=" <> path, query: opts)
    |> okify()
  end

  @doc """
  Write to a mutable file in a given filesystem.

  ## Parameters
  `path` - The path to write to.
  `data` - The data to write.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-files-write
  ```
  [
    create: <bool>, # Create the file if it does not exist.
    truncate: <bool>, # Truncate the file to size zero before writing.
    offset: <int>, # Byte offset to begin writing at.
    count: <int>, # Maximum number of bytes to write.
    raw-leaves: <bool>, # Use raw blocks for newly created leaf nodes. (experimental)
    cid-version: <int>, # CID version. (experimental)
    hash: <string>, # Hash function to use. Implies CID version 1 if used. (experimental)
    parents: <bool>, # No error if existing, make parent directories as needed.
  ]
  ```
  """
  @spec write(fspath, path, opts) :: {:ok, any} | api_error()
  def write(data, path, opts \\ []) do
    multipart_content(data)
    |> post_multipart("/files/write?arg=" <> path, query: opts)
    |> okify()
  end
end
