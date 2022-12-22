defmodule MyspaceIPFS.Api.Dag do
  @moduledoc """
  MyspaceIPFS.Api.Dag is where the cid commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api

  def get(object), do: post_query("/dag/get?arg=" <> object)

  def put(filename, opts \\ []), do: post_file("/dag/put", filename, opts)
end
