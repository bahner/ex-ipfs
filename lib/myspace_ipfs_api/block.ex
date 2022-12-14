defmodule MyspaceIPFS.Api.Block do
  @moduledoc """
  MyspaceIPFS.Api.Blocki is where the commands commands of the IPFS API reside.
  """
  import MyspaceIPFS.Connection
  import MyspaceIPFS.Utils

  def get(arg), do: request_get("/block/get?arg=", arg)

  def put(file_path),
    do: setup_multipart_form(file_path) |> request_post("/block/put")

  def rm(multihash), do: request_get("/block/rm?arg=", multihash)

  def stat(multihash), do: request_get("/block/stat?arg=", multihash)
end
