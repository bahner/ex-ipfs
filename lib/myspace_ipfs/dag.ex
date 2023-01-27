defmodule MyspaceIpfs.Dag do
  @moduledoc """
  MyspaceIpfs.Dag is where the cid commands of the IPFS API reside.
  """
  import MyspaceIpfs.Api
  import MyspaceIpfs.Utils

  @typep cid :: MyspaceIpfs.cid()
  @typep okresult :: MyspaceIpfs.okresult()
  @typep opts :: MyspaceIpfs.opts()
  @typep path :: MyspaceIpfs.path()

  @doc """
  Streams the selected DAG as a .car stream on stdout.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-dag-export

  No options are relevant for this command.
  """
  @spec export(cid) :: okresult
  def export(cid) do
    post_query("/dag/export?arg=" <> cid)
    |> handle_api_response()
    |> okify()
  end

  @doc """
  Get a DAG node.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-dag-get
  """
  @spec get(path, opts) :: okresult
  def get(path, opts \\ []) do
    post_query("/dag/get?arg=" <> path, query: opts)
    |> handle_api_response()
    |> okify()
  end

  @doc """
  Import the contents of a DAG.

  The IPFS API does not currently support posting data directly to the endpoint. So
  we have to write the data to a temporary file and then post that file.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-dag-import
  """
  @spec import(binary, opts) :: okresult
  def import(data, opts \\ []) do
    multipart_content(data)
    |> post_multipart("/dag/import", query: opts)
    |> handle_api_response()
    |> snake_atomize()
    |> MyspaceIpfs.DagImport.new()
    |> okify()
  end

  @doc """
  Put an object to be encoded as a DAG object. There seems to be a bug in the
  IPFS API where the data is not being parsed correctly. Simple export can not be reimported at the moment.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-dag-put
  ```
  [
    store-codec: "<string>", # Default: "dag-cbor"
    input-codec: "<string>", # Default: "dag-json"
    pin: "<bool>", # Whether to pin object when adding. Default: false
    hash: "<string>", # Hash function to use. Default: "sha2-256"
    allow-big-block: <bool>, # Allow blocks larger than 1MB. Default: false
  ]
  ```
  """
  @spec put(binary, opts) :: okresult
  def put(data, opts \\ []) do
    multipart_content(data)
    |> post_multipart("/dag/put", query: opts)
    |> handle_api_response()
  end
end
