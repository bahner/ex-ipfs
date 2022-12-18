defmodule MyspaceIPFS.Api.Data.Block do
  @moduledoc """
  MyspaceIPFS.Api.Blocki is where the commands commands of the IPFS API reside.
  """
  import MyspaceIPFS

  @spec get(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def get(arg), do: post_query("/block/get?arg=", arg)

  @spec put(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def put(file_path),
    do: post_file("/block/put", file_path)

  @spec rm(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def rm(multihash), do: post_query("/block/rm?arg=", multihash)

  @spec stat(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def stat(multihash), do: post_query("/block/stat?arg=", multihash)
end
