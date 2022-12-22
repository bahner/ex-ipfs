defmodule MyspaceIPFS.Bootstrap do
  @moduledoc """
  MyspaceIPFS.Api is where the bootstrap commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api

  # BOOTSTRAP COMMANDS
  # FIXME: bootstrap is not implemented yet.
  # FIXME: add is not implemented yet.
  def add_default, do: post_query("/bootstrap/add/default")

  def list, do: post_query("/bootstrap/list")

  def rm_all, do: post_query("bootstrap/rm/all")
end
