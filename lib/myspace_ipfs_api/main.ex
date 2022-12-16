defmodule MyspaceIPFS.Api.Main do
    @moduledoc """
  MyspaceIPFS.Api is where the main commands of the IPFS API reside.
  """

    # TODO: add various flags to the add.
    def add(file_path), do: setup_multipart_form(file_path) |> request_post("/add")

    def id, do: request_get("/id")

    ## TODO: add get for output, archive, compress and compression level
    def get(multihash) when is_bitstring(multihash), do: request_get("/get?arg=", multihash)

    def cat(multihash) when is_bitstring(multihash), do: request_get("/cat?arg=", multihash)

    #Ls cmd TODO  Implement proper Json Format.
    def ls(multihash) when is_bitstring(multihash), do: request_get("/ls?arg=", multihash)

    def resolve(multihash), do: request_get("/resolve?arg=", multihash)

    def ping(id), do: request("/ping?arg=", id)

    def mount, do: request_get("/mount")

    #Update function  - takes in the current args for update.
    def update(args) when is_bitstring(args) do
        {:ok, res} = request_get("/update?arg=", args)
        res.body|> String.replace(~r/\r|\n/, "")
    end

    #version function - does not currently accept the optional arguments on golang client.
    def version(num \\ false, comm \\ false, repo \\ false, all \\ false) do
       request_get("/version?number=" <> to_string(num) <> "&commit=" <> to_string(comm) <> "&repo=" <> to_string(repo) <> "&all=" <> to_string(all) , "")
    end

    defp shutdown(pid, term) do
      Process.exit(pid, term)
  end

end
