defmodule MyspaceIPFS.Api.Files do
    @moduledoc """
  MyspaceIPFS.Api is where the files commands of the IPFS API reside.
  """
    def files_cp(source, dest), do: request_get("/files/cp?arg=" <> source <>  "&arg=" <> dest)

    def files_flush, do: request_get("/files/flush")

    def files_ls, do: request_get("/files/ls")

    def files_mkdir(path), do: request_get("/files/mkdir?arg=", path)

    def files_mv(source, dest), do: request_get("/files/mv?arg=" <> source <> "&arg=" <> dest)

    def files_read(path), do: request_get("/files/read?arg=", path)

    def files_rm(path), do: request_get("/files/rm?arg=", path)

    def files_stat(path), do: request_get("/files/stat?arg=", path)

    def files_write(path, data), do: setup_multipart_form(data) |> request_post("/files/write?arg=" <> path)
end
