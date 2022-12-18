defmodule MyspaceIPFS.Api.Network.Bootstrap do
  @moduledoc """
  MyspaceIPFS.Api is where the bootstrap commands of the IPFS API reside.
  """
  import MyspaceIPFS

  # BOOTSTRAP COMMANDS
  # FIXME: bootstrap is not implemented yet.
  # FIXME: add is not implemented yet.
  @spec add_default :: any
  def add_default, do: post_query("/bootstrap/add/default")

  @spec list :: any
  def list, do: post_query("/bootstrap/list")

  @spec rm_all :: any
  def rm_all, do: post_query("bootstrap/rm/all")
end
