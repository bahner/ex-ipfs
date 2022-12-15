defmodule MyspaceIPFS.Api.Basic do
  @moduledoc """
  MyspaceIPFS.Api is where the main commands of the IPFS API reside.
  """

  import MyspaceIPFS.Utils
  import MyspaceIPFS.Connection

  # TODO: add various flags to the add.

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
end
