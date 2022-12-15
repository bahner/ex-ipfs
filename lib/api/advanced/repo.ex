defmodule MyspaceIPFS.Api.Advanced.Repo do
  @moduledoc """
  MyspaceIPFS.Api.Repo is where the repo commands of the IPFS API reside.
  """

  import MyspaceIPFS.Utils

  ## Currently throws an error due to the size of JSON response.
  @spec verify :: any
  def verify, do: request_get("/repo/verify")

  @spec version :: any
  def version, do: request_get("/repo/version")

  @spec stat :: any
  def stat, do: request_get("/repo/stat")

  @spec gc :: any
  def gc, do: request_get("/repo/gc")
end
