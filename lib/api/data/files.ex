defmodule MyspaceIPFS.Api.Data.Files do
  @moduledoc """
  MyspaceIPFS.Api is where the files commands of the IPFS API reside.
  """

  import MyspaceIPFS

  @spec cp(binary, binary) :: any
  def cp(source, dest), do: post_query("/files/cp?arg=" <> source <> "&arg=" <> dest)

  @spec flush :: any
  def flush, do: post_query("/files/flush")

  @spec ls :: any
  def ls, do: post_query("/files/ls")

  @spec mkdir(binary) :: any
  def mkdir(path), do: post_query("/files/mkdir?arg=", path)

  @spec mv(binary, binary) :: any
  def mv(source, dest), do: post_query("/files/mv?arg=" <> source <> "&arg=" <> dest)

  @spec read(binary) :: any
  def read(path), do: post_query("/files/read?arg=", path)

  @spec rm(binary) :: any
  def rm(path), do: post_query("/files/rm?arg=", path)

  @spec stat(binary) :: any
  def stat(path), do: post_query("/files/stat?arg=", path)

  @spec write(binary, binary) :: any
  def write(path, path),
    do: post_file("/files/write?arg=" <> path, path)
end
