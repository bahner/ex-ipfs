defmodule MyspaceIPFS.Api do
  @moduledoc """
  MyspaceIPFS.Api is where the main commands of the IPFS API reside.
  Alias this library and you can run the commands via Api.<cmd_name>.

        ## Examples

        iex> alias MyspaceIPFS.API, as: Api
        iex> Api.get("Multihash_key")
        <<0, 19, 148, 0, ... >>
  """

  import MyspaceIPFS
  @experimental Application.get_env(:myspace_ipfs, :experimental)

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

  @type result :: MyspaceIPFS.result()
  @type path :: MyspaceIPFS.path()
  @type opts :: MyspaceIPFS.opts()
  @type fspath :: MyspaceIPFS.fspath()
  @type name :: MyspaceIPFS.name()

  @doc """
  Shutdown the IPFS daemon.
  """
  @spec shutdown :: result
  def shutdown, do: post_query("/shutdown")

  @doc """
  Resolve the value of names to IPFS.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-resolve
  Example of options:
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
  Add a file to IPFS. For options see the IPFS docs.
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-add
  """
  @spec add(fspath, opts) :: result
  def add(fspath, opts \\ []),
    do:
      post_file("/add", fspath, opts)
      |> map_response_data()
      |> okify()

  # TODO: add get for output, archive, compress and compression level
  @doc """
  Get a file or directory from IPFS.
  As it stands ipfs sends a text blob back, so we need to implement a way to
  get the file extracted and saved to disk.

  For options see the IPFS docs.
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-get
  """
  @spec get(path, opts) :: result
  # def get(path, opts \\ []), do: post_query("/get?arg=" <> path, opts)
  def get(_, _ \\ []), do: {:error, "FIXME: Not implemented yet."}

  @doc """
  Get the contents of a file from ipfs.
  Easy way to get the contents of a text file for instance.

  For options see the IPFS docs.
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

  Returns a map with the following keys:

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
