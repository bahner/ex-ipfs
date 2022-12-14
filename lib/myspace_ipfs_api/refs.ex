defmodule MyspaceIPFS.Api.Refs do
  @moduledoc """
  MyspaceIPFS.Api.Refs is where the main commands of the IPFS API reside.
  """
  import MyspaceIPFS.Utils

  # FIXME: refs is not implemented yet.

  @spec local :: any
  def local, do: request_get("/refs/local")
end
