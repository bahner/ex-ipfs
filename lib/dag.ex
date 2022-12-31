defmodule MyspaceIPFS.Dag do
  @moduledoc """
  MyspaceIPFS.Dag is where the cid commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @typep cid :: MyspaceIPFS.cid()
  @typep okresult :: MyspaceIPFS.okresult()
  @typep opts :: MyspaceIPFS.opts()
  @typep fspath :: MyspaceIPFS.fspath()

  @doc """
  Streams the selected DAG as a .car stream on stdout.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-dag-export

  No options are relevant for this command.
  """
  @spec export(cid) :: okresult
  def export(cid) do
    post_query("/dag/export?arg=" <> cid)
  end

  @doc """
  Get a DAG node.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-dag-get
  """
  @spec get(cid, opts) :: okresult
  def get(cid, opts \\ []) do
    post_query("/dag/get?arg=" <> cid, query: opts)
    |> handle_json_response()
  end

  @doc """
  Import the contents of a DAG.

  The IPFS API does not currently support posting data directly to the endpoint. So
  we have to write the data to a temporary file and then post that file.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-dag-import
  """
  @spec import(fspath, opts) :: okresult
  def import(filename, opts \\ []) do
    post_file("/dag/import", filename, query: opts)
    |> handle_json_response()
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
  @spec put(fspath, opts) :: okresult
  def put(fspath, opts \\ []) do
    post_file("/dag/put", fspath, query: opts)
    |> handle_json_response()
  end
end
