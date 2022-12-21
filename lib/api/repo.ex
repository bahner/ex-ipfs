defmodule MyspaceIPFS.Api.Repo do
  @moduledoc """
  MyspaceIPFS.Api.Repo is where the repo commands of the IPFS API reside.
  """
  import MyspaceIPFS

  ## Currently throws an error due to the size of JSON response.
  def verify, do: post_query("/repo/verify")

  def version, do: post_query("/repo/version")

  def stat, do: post_query("/repo/stat")

  def gc, do: post_query("/repo/gc")
end
