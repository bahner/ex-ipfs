defmodule MyspaceIPFS.Api.Block do
  @moduledoc """
  MyspaceIPFS.Api.Blocki is where the commands commands of the IPFS API reside.
  """
  import MyspaceIPFS

  def get(arg), do: post_query("/block/get?arg=" <> arg)

  def put(file_path),
    do: post_file("/block/put", file_path)

  def rm(multihash), do: post_query("/block/rm?arg=" <> multihash)

  def stat(multihash), do: post_query("/block/stat?arg=" <> multihash)
end
