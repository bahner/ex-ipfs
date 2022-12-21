defmodule MyspaceIPFS.Api.Name do
  @moduledoc """
  MyspaceIPFS.Api.Name is where the name commands of the IPFS API reside.
  """
  import MyspaceIPFS

  def publish(path), do: post_query("/name/publish?arg=" <> path)

  def resolve, do: post_query("/name/resolve")
end
