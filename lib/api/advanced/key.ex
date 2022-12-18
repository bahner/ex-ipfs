defmodule MyspaceIPFS.Api.Advanced.Key do
  @moduledoc """
  MyspaceIPFS.Api is where the key commands of the IPFS API reside.
  """
  import MyspaceIPFS

  def gen(key), do: post_query("/key/gen?arg=" <> key)

  def list, do: post_query("/key/list")
end
