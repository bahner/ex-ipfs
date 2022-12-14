defmodule MyspaceIPFS.Api.Name do
  @moduledoc """
  MyspaceIPFS.Api.Name is where the name commands of the IPFS API reside.
  """
  import MyspaceIPFS.Utils

  @spec publish(binary) :: any
  def publish(path), do: request_get("/name/publish?arg=", path)

  @spec resolve :: any
  def resolve, do: request_get("/name/resolve")
end
