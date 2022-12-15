defmodule MyspaceIPFS.Api.Data.Block do
  @moduledoc """
  MyspaceIPFS.Api.Blocki is where the commands commands of the IPFS API reside.
  """
  import MyspaceIPFS.Connection
  import MyspaceIPFS.Utils

  @spec get(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def get(arg), do: request_get("/block/get?arg=", arg)

  @spec put(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def put(file_path),
    do: setup_multipart_form(file_path) |> request_post("/block/put")

  @spec rm(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def rm(multihash), do: request_get("/block/rm?arg=", multihash)

  @spec stat(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def stat(multihash), do: request_get("/block/stat?arg=", multihash)
end
