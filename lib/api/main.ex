defmodule MyspaceIPFS.Api.Main do
  @moduledoc """
  MyspaceIPFS.Api is where the main commands of the IPFS API reside.
  """

  import MyspaceIPFS.Utils
  import MyspaceIPFS.Connection

  # TODO: add various flags to the add.

  @spec id :: any
  def id, do: request_get("/id")

  @spec mount :: any
  def mount, do: request_get("/mount")

  @spec shutdown :: any
  def shutdown, do: request_get("/shutdown")

  @spec add(binary) :: any
  def add(file_path), do: setup_multipart_form(file_path) |> request_post("/add")

  ## TODO: add get for output, archive, compress and compression level
  @spec get(binary) :: any
  def get(multihash) when is_bitstring(multihash), do: request_get("/get?arg=", multihash)

  @spec cat(binary) :: any
  def cat(multihash) when is_bitstring(multihash), do: request_get("/cat?arg=", multihash)

  # Ls cmd TODO  Implement proper Json Format.
  @spec ls(binary) :: any
  def ls(multihash) when is_bitstring(multihash), do: request_get("/ls?arg=", multihash)

  @spec resolve(binary) :: any
  def resolve(multihash), do: request_get("/resolve?arg=", multihash)

  @spec ping(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def ping(id), do: request_get("/ping?arg=", id)

  # Update function  - takes in the current args for update.
  @spec update(binary) :: binary
  def update(args) when is_bitstring(args) do
    {:ok, res} = request_get("/update?arg=", args)
    res.body |> String.replace(~r/\r|\n/, "")
  end

  # version function - does not currently accept the optional arguments on golang client.
  @spec version(any, any, any, any) :: any
  def version(num \\ false, comm \\ false, repo \\ false, all \\ false) do
    request_get(
      "/version?number=" <>
        to_string(num) <>
        "&commit=" <> to_string(comm) <> "&repo=" <> to_string(repo) <> "&all=" <> to_string(all),
      ""
    )
  end
end
