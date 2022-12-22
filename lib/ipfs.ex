defmodule MyspaceIPFS do
  @moduledoc """
  MyspaceIPFS.Api is where the main commands of the IPFS API reside.
  Alias this library and you can run the commands via Api.<cmd_name>.

        ## Examples

        iex> alias MyspaceIPFS.API, as: Api
        iex> Api.get("Multihash_key")
        <<0, 19, 148, 0, ... >>
  """

  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @experimental Application.get_env(:myspace_ipfs, :experimental)

  # Types
  @typedoc """
  The path to the endpoint to be hit. For example, `/add` or `/cat`.
  It's called path because sometimes the MultiHash is not enough to
  identify the resource, and a path is needed, eg. /ipns/myspace.bahner.com
  """
  @type path :: String.t()
  @typedoc """
  The file system path to the file to be sent to the node.
  """
  @type fspath :: String.t()
  @typedoc """
  The name of the file or data to be sent to the node.
  """
  @type name :: String.t()
  @typedoc """
  The options to be sent to the node. These are dependent on the endpoint
  """
  @type opts :: list

  @typedoc """
  The structure of a normal error response from the node.
  """
  @type error ::
          {:error, Tesla.Env.t()}
          | {:eserver, Tesla.Env.t()}
          | {:eclient, Tesla.Env.t()}
          | {:eaccess, Tesla.Env.t()}
          | {:emissing, Tesla.Env.t()}
          | {:enoallow, Tesla.Env.t()}
  @typedoc """
  The structure of a normal response from the node.
  """
  @type mapped :: {:ok, list} | {:error, Tesla.Env.t()}
  @typedoc """
  The structure of a JSON response from the node.
  """
  @type result :: {:ok, any} | {:error, Tesla.Env.t()}

  # TODO: add ability to add options to the ipfs daemon command.
  # TODO: handle experimental.
  def start_shell(start? \\ true, flag \\ []) do
    {:ok, pid} = Task.start(fn -> System.cmd("ipfs", ["daemon"]) end)

    if start? == false do
      pid |> shutdown(flag)
    else
      pid
    end
  end

  defp shutdown(pid, term) do
    Process.exit(pid, term)
  end

  @doc """
  Shutdown the IPFS daemon.
  """
  @spec shutdown :: result
  def shutdown, do: post_query("/shutdown")

  @doc """
  Resolve the value of names to IPFS.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-resolve
  ```
  [
    recursive: true,
    nocache: true,
    dht-record-count: 10,
    dht-timeout: 10
  ]
  ```
  """
  @spec resolve(path, opts) :: result
  def resolve(path, opts \\ []),
    do:
      post_query("/resolve?arg=" <> path, opts)
      |> map_response_data()
      |> okify()

  @doc """
  Add a file to IPFS.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-add
  """
  @spec add(fspath, opts) :: result
  def add(fspath, opts \\ []),
    do:
      post_file("/add", fspath, opts)
      |> map_response_data()
      |> okify()

  @doc """
  Get a file or directory from IPFS.
  As it stands ipfs sends a text blob back, so we need to implement a way to
  get the file extracted and saved to disk.

  Compression is not implemented yet. IPFS sends a plain tarball anyhow, so there's
  no serious need to compress it.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-get
  ```
  [
    output: <string>, # Optional, default: Name of the object. CID or path basename.
    archive: <bool>, # Optional, default: false
    compress: <bool>, # NOT IMPLEMENTED
    compression_level: <int> # NOT IMPLEMENTED
  ]
  ```
  """

  @spec get(path, opts) :: result
  defdelegate get(path, opts \\ []), to: MyspaceIPFS.Get
  # defp handle_file_write(data, opts),
  #   do:
  #     with(
  #       compress <- Keyword.get(opts, :compress, false),
  #       compression_level <- Keyword.get(opts, :compression_level, 0),
  #       do: File.write!(output, data)
  #     )

  @doc """
  Get the contents of a file from ipfs.
  Easy way to get the contents of a text file for instance.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-cat
  """
  @spec cat(path, opts) :: result
  def cat(path, opts \\ []),
    do:
      post_query("/cat?arg=" <> path, opts)
      |> map_response_data()
      |> okify()

  @doc """
    List the files in an IPFS object.
  """
  @spec ls(path, opts) :: result
  def ls(path, opts \\ []),
    do:
      post_query("/ls?arg=" <> path, opts)
      |> map_response_data()
      |> okify()

  @doc """
  Show the id of the IPFS node.

  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-id
  Returns a map with the following keys:
    - ID: the id of the node.
    - PublicKey: the public key of the node.
    - Addresses: the addresses of the node.
    - AgentVersion: the version of the node.
    - ProtocolVersion: the protocol version of the node.
    - Protocols: the protocols of the node.
  """
  @spec id :: result
  def id,
    do:
      post_query("/id")
      |> map_response_data()
      |> filter_empties()
      |> unlist()
      |> okify()

  @doc """
  Ping a peer.
  ## Parameters
  - peer: the peer to ping.
  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-ping
  ```
  [
    n|count: <int>,
  ]
  ```
  """
  @spec ping(name, opts) :: result
  def ping(peer, opts \\ []),
    do:
      post_query("/ping?arg=" <> peer, opts)
      |> map_response_data()
      |> okify()

  if @experimental do
    @doc """
    Mount an IPFS read-only mountpoint.

    ## Options
    https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-mount
    ```
    [
      ipfs-path: <string>, # default: /ipfs
      ipns-path: <string>, # default: /ipns
    ]
    ```
    """
    @spec mount(opts) :: result
    def mount(opts \\ []) do
      case @experimental do
        true ->
          post_query("/mount", opts)
          |> map_response_data()
          |> okify()

        false ->
          raise "This command is experimental and must be enabled in the config."
      end
    end
  end
end
