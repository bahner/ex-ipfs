defmodule MyspaceIPFS.Api.Advanced.Filestore do
  @moduledoc """
  MyspaceIPFS.Api is where the filestore commands of the IPFS API reside.
  """
  import MyspaceIPFS.Utils

  @spec dups :: any
  def dups, do: request_get("/filestore/dups")

  @spec ls :: any
  def ls, do: request_get("/filestore/ls")

  @spec verify :: any
  def verify, do: request_get("/filestore/verify")
end
