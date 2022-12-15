defmodule MyspaceIPFS.Api.Data.Dag do
  @moduledoc """
  MyspaceIPFS.Api.Dag is where the cid commands of the IPFS API reside.
  """
  import MyspaceIPFS.Connection
  import MyspaceIPFS.Utils

  def get(object), do: request_get("/dag/get?arg=", object)

  def put(file_path),
    do: setup_multipart_form(file_path) |> request_post("/dag/put")
end
