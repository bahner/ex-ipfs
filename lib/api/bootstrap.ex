defmodule MyspaceIPFS.Api.Bootstrap do
  @moduledoc """
  MyspaceIPFS.Api is where the bootstrap commands of the IPFS API reside.
  """
  import MyspaceIPFS.Utils

  # BOOTSTRAP COMMANDS
  # FIXME: bootstrap is not implemented yet.
  # FIXME: add is not implemented yet.
  @spec add_default :: any
  def add_default, do: request_get("/bootstrap/add/default")

  @spec list :: any
  def list, do: request_get("/bootstrap/list")

  @spec rm_all :: any
  def rm_all, do: request_get("bootstrap/rm/all")
end
