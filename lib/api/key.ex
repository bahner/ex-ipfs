defmodule MyspaceIPFS.Api.Key do
  @moduledoc """
  MyspaceIPFS.Api is where the key commands of the IPFS API reside.
  """
  import MyspaceIPFS.Utils

  @spec gen(binary) :: any
  def gen(key), do: request_get("/key/gen?arg=", key)

  @spec list :: any
  def list, do: request_get("/key/list")
end
