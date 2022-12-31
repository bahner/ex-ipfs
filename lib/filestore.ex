defmodule MyspaceIPFS.Filestore do
  @moduledoc """
  MyspaceIPFS.Api is where the filestore commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @typep okresult :: MyspaceIPFS.okresult()
  @typep opts :: MyspaceIPFS.opts()

  @doc """
  List blocks that are both in the filestore and standard block storage.
  """
  @spec dups() :: okresult
  def dups do
     post_query("/filestore/dups")
     |> handle_json_response()
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
  @spec ls(opts) :: okresult
  def ls(opts \\ []) do
     post_query("/filestore/ls", query: opts)
      |> handle_json_response()
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
  @spec verify(opts) :: okresult
  def verify(opts \\ []) do
     post_query("/filestore/verify", query: opts)
     |> handle_json_response()
  end
end
