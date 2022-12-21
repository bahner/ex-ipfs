defmodule MyspaceIPFS.Api.Filestore do
  @moduledoc """
  MyspaceIPFS.Api is where the filestore commands of the IPFS API reside.
  """
  import MyspaceIPFS

  @doc """
  List blocks that are both in the filestore and standard block storage.
  """
  def dups, do: post_query("/filestore/dups")

  @doc """
  List objects in the filestore.
  """
  def ls, do: post_query("/filestore/ls")

  @doc """
  verify that objects in the filestore are not corrupted.
  """
  def verify, do: post_query("/filestore/verify")
end
