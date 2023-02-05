defmodule MyspaceIPFS.Dag do
  @moduledoc """
  MyspaceIPFS.Dag is where the cid commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils
  alias MyspaceIPFS.DagImport
  alias MyspaceIPFS.SlashCID
  require Logger

  @doc """
  Streams the selected DAG as a .car stream on stdout.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-dag-export

  No options are relevant for this command.
  """
  # FIXME return a struct
  @spec export(binary()) :: {:ok, any} | MyspaceIPFS.ApiError.t()
  def export(cid) do
    post_query("/dag/export?arg=" <> cid)
    |> okify()
  end

  @doc """
  Get a DAG node.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-dag-get
  """
  # FIXME return a struct
  @spec get(Path.t(), list()) :: {:ok, any} | MyspaceIPFS.ApiError.t()
  def get(path, opts \\ []) do
    with data <- post_query("/dag/get?arg=" <> path, query: opts) do
      data
      |> Jason.decode!()
      |> okify()
    end
  end

  @doc """
  Import the contents of a DAG.

  The IPFS API does not currently support posting data directly to the endpoint. So
  we have to write the data to a temporary file and then post that file.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-dag-import
  """
  @spec import(binary, list()) :: {:ok, DagImport.t()} | MyspaceIPFS.ApiError.t()
  def import(data, opts \\ []) do
    Logger.debug("import: #{inspect(opts)}")
    opts = Keyword.put(opts, :stats, true)

    multipart_content(data)
    |> post_multipart("/dag/import", query: opts)
    |> DagImport.new()
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
  @spec put(binary, list()) :: {:ok, SlashCID.t()} | MyspaceIPFS.ApiError.t()
  def put(data, opts \\ []) do
    multipart_content(data)
    |> post_multipart("/dag/put", query: opts)
    |> Map.get("Cid", nil)
    |> SlashCID.new()
    |> okify()
  end
end
