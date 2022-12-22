defmodule MyspaceIPFS.Files do
  @moduledoc """
  MyspaceIPFS.Api is where the files commands of the IPFS API reside.
  """

  import MyspaceIPFS.Api

  def cp(source, dest), do: post_query("/files/cp?arg=" <> source <> "&arg=" <> dest)

  def flush, do: post_query("/files/flush")

  def ls, do: post_query("/files/ls")

  def mkdir(path), do: post_query("/files/mkdir?arg=" <> path)

  def mv(source, dest), do: post_query("/files/mv?arg=" <> source <> "&arg=" <> dest)

  def read(path), do: post_query("/files/read?arg=" <> path)

  def rm(path), do: post_query("/files/rm?arg=" <> path)

  def stat(path), do: post_query("/files/stat?arg=" <> path)

  def write(path, path),
    do: post_file("/files/write?arg=" <> path, path)
end
