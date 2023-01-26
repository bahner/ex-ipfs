defmodule MyspaceIpfs do
  @moduledoc """
  MyspaceIpfs is where the main commands of the IPFS API reside.
  Alias this library and you can run the commands via Api.<cmd_name>.

        ## Examples

        iex> alias MyspaceIpfs, as: Ipfs
        iex> Ipfs.cat(QmZ4tDuvesekSs4qM5ZBKpXiZGun7S2CYtEZRB3DYXkjGx")
        <<0, 19, 148, 0, ... >>
  """

  import MyspaceIpfs.Api
  import MyspaceIpfs.Utils

  # Types
  @typedoc """
  The name of the file or data to be sent to the node. Sometimes you cant't
  use paths, but have to use a cid. This is because prefixes like /ipfs/ or
  /ipns/ are not allowed.
  FIXME: create a type for cid
  """
  @type cid :: atom | String.t()

  @typedoc """
  B58 encoded peer ID.
  """
  @type peer_id() :: <<_::48, _::_*8>>

  @typedoc """
  The file system path to the file to be sent to the node.
  Because <cid>, /ipfs/<cid> or /ipns/<cid> are all allowed it looks like a path.
  """
  @type fspath :: Path.t()

  @typedoc """
  The options to be sent to the node. These are dependent on the endpoint.
  it's because prefixes like /ipfs/ or /ipns/ are not allowed.
  """
  @type opts :: list

  @typedoc """
  The path to the endpoint to be hit. For example, `/add` or `/cat`.
  It's called path because sometimes the MultiHash is not enough to
  identify the resource, and a path is needed, eg. /ipns/myspace.bahner.com
  """
  @type path :: Path.t()

  @typedoc """
  The structure of a normal error response from the node.
  """
  @type tesla_error :: {:error, Tesla.Env.t()}
  @typedoc """
  The structure of a normal response from the node.
  """
  @type okmapped :: {:ok, list} | tesla_error
  @typedoc """
  The structure of a JSON response from the node with :ok or :error.
  """
  @type okresult :: {:ok, any} | tesla_error
  @typedoc """
  The structure of a JSON response from the node.
  """
  @type result :: any | tesla_error
  @typedoc """
  A simple :ok or :error response from the node.
  """
  @type ok :: {:ok} | tesla_error

  @doc """
  Start the IPFS daemon.

  You should run this before any other command, but it's probably easier to do outside of the library.

  The flag is the signal to send to the daemon process when shutting it down, ie. when start? is false.
  The default is `:normal`.

  ## Options
  https://docs.ipfs.tech/reference/kubo/cli/#ipfs-daemon

  ```
  [
    "--init", # <bool> Initialize IPFS with default settings, if not already initialized
    "--migrate", # <bool> If answer yes to migration prompt
    "--init-config <string>", # Path to the configuration file to use
    "--init-profile <string>", # Apply profile settings to config
    "--routing <string>", # Override the routing system
    "--mount", # <bool> Mount IPFS to the filesystem (experimental)
    "--writable", # <bool> Enable writing objects (with POST, PUT, DELETE)
    "--mount-ipfs <string>", # Path to the mountpoint for IPFS (if using --mount)
    "--mount-ipns <string>", # Path to the mountpoint for IPNS (if using --mount)
    "--unrestricted-api", # <bool> Allow API access to unlisted hashes
    "--disable-transport-encryption", # <bool> Disable transport encryption (for debugging)
    "--enable-gc", # <bool> Enable automatic repo garbage collection
    "--enable-pubsub-experiment", # <bool> Enable experimental pubsub
    "--enable-namesys-pubsub", # <bool> Enable experimental namesys pubsub
    "--agent-version-suffix <string>", # Suffix to append to the AgentVersion string for id()
  ]
  ```
  """
  @spec daemon(boolean, atom, opts) :: pid
  def daemon(start? \\ true, signal \\ :normal, opts \\ []) do
    {:ok, pid} = Task.start(fn -> System.cmd("ipfs", ["daemon"] ++ opts) end)

    if start? == false do
      pid |> shutdown_daemon_process(signal)
    else
      pid
    end
  end

  defp shutdown_daemon_process(pid, term) do
    Process.exit(pid, term)
  end

  @doc """
  Shutdown the IPFS daemon.
  """
  @spec shutdown() :: ok
  def shutdown do
    post_query("/shutdown")
    {:ok}
  end

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
  @spec resolve(path, opts) :: okresult
  def resolve(path, opts \\ []),
    do:
      post_query("/resolve?arg=" <> path, query: opts)
      |> handle_api_response()
      |> okify()

  @doc """
  Add a file to IPFS.

  ## Parameters
  * `fspath` - The file system path to the file or directory to be sent to the node.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-add


  """
  @spec add(fspath, opts) :: result
  def add(fspath, opts \\ []),
    do:
      multipart(fspath)
      |> post_multipart("/add", query: opts)
      |> handle_api_response()
      |> okify()

  @doc """
  Get a file or directory from IPFS.

  *NB! Unsafe (relative symlinks) will raise an error.* This is a limitation of the underlying library.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-get
  ```
  [
    output: <string>, # Output to file or directory name. Optional, default: <cid-ipfs-or-ipns-path>
    archive: <bool>, # Output as a tarball. Optional, default: false
    timeout: <int64>, # Timeout in seconds. Optional, default: 100
  ]
  ```
  Compression is not implemented.

  If you feel that you need more timeouts, you can use the `:timeout` option in the `opts` list.
  But the default should be enough for most cases. More likely your content isn't available....
  """
  @spec get(path, opts) :: okresult
  defdelegate get(path, opts \\ []), to: MyspaceIpfs.Get

  @doc """
  Get the contents of a file from ipfs.
  Easy way to get the contents of a text file for instance.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-cat
  ```
  [
    offset: <int64>,
    length: <int64>,
    progress: <bool>
  ]
  ```
  """
  @spec cat(path, opts) :: result
  def cat(path, opts \\ []),
    do:
      post_query("/cat?arg=" <> path, query: opts)
      |> handle_api_response()

  @doc """
  List the files in an IPFS object.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-ls
  ```
  [
    headers: <bool>,
    resolve-type: <bool>,
    stream: <bool>,
    size: <bool>,
  ]
  ```

  ## Response
  ```
  {
    Objects: [
      {
        "Name": "string",
        "Hash": "string",
        "Size": 0,
        "Type": 0,
        "Links": [
          {
            "Name": "string",
            "Hash": "string",
            "Size": 0,
            "Type": 0
          }
        ]
      }
    ]
  }
  ```
  """
  @spec ls(path, opts) :: okresult
  def ls(path, opts \\ []),
    do:
      post_query("/ls?arg=" <> path, query: opts)
      |> handle_api_response()
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
  @spec id :: okresult
  def id,
    do:
      post_query("/id")
      |> handle_api_response()
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
    timeout: <int>,
  ]
  ```
  """
  # FIXME: pass the query opts to query. Shouldn't be too difficult.
  # But needs doing.
  @spec ping(pid, cid, atom | integer, opts) :: :ok
  def ping(pid, peer, timeout, opts \\ []),
    do: MyspaceIpfs.Ping.start_link(pid, peer, timeout, opts)

  :ok

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
  @spec mount(opts) :: okresult
  def mount(opts \\ []),
    do:
      post_query("/mount", query: opts)
      |> handle_api_response()
      |> okify()
end
