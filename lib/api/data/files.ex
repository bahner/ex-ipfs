defmodule MyspaceIPFS.Api.Data.Files do
  @moduledoc """
  MyspaceIPFS.Api is where the files commands of the IPFS API reside.
  """

  import MyspaceIPFS.Connection
  import MyspaceIPFS.Utils

  @spec cp(binary, binary) :: any
  def cp(source, dest), do: request_get("/files/cp?arg=" <> source <> "&arg=" <> dest)

  @spec flush :: any
  def flush, do: request_get("/files/flush")

  @spec ls :: any
  def ls, do: request_get("/files/ls")

  @spec mkdir(binary) :: any
  def mkdir(path), do: request_get("/files/mkdir?arg=", path)

  @spec mv(binary, binary) :: any
  def mv(source, dest), do: request_get("/files/mv?arg=" <> source <> "&arg=" <> dest)

  @spec read(binary) :: any
  def read(path), do: request_get("/files/read?arg=", path)

  @spec rm(binary) :: any
  def rm(path), do: request_get("/files/rm?arg=", path)

  @spec stat(binary) :: any
  def stat(path), do: request_get("/files/stat?arg=", path)

  @spec write(binary, binary) :: any
  def write(path, data),
    do: setup_multipart_form(data) |> request_post("/files/write?arg=" <> path)
end
