defmodule ExIPFS.Filestore do
  @moduledoc """
  ExIPFS.Filestore is where the filestore commands of the IPFS API reside.
  """
  import ExIPFS.Api
  import ExIPFS.Utils

  @doc """
  List blocks that are both in the filestore and standard block storage.
  """
  @spec dups() :: {:ok, any} | ExIPFS.Api.error_response()
  def dups do
    post_query("/filestore/dups")
    |> okify()
  end

  @doc """
  List objects in the filestore.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-filestore-ls
  ```
  [
    arg: <string>, # CID of objects to list.
    file-order: <bool>, # sort the results based on the path of the backing file.
  ]
  ```
  """
  @spec ls(list()) :: {:ok, any} | ExIPFS.Api.error_response()
  def ls(opts \\ []) do
    post_query("/filestore/ls", query: opts)
    |> okify()
  end

  @doc """
  Verify objects in the filestore.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-filestore-verify
  ```
  [
    arg: <string>, # CID of objects to list.
    file-order: <bool>, # sort the results based on the path of the backing file.
  ]
  ```
  """
  @spec verify(list()) :: {:ok, any} | ExIPFS.Api.error_response()
  def verify(opts \\ []) do
    post_query("/filestore/verify", query: opts)
    |> okify()
  end
end
