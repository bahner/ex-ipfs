defmodule MyspaceIPFS do
  @moduledoc """
  MyspaceIPFS is where the main commands of the IPFS API reside.
  Alias this library and you can run the commands via Api.<cmd_name>.

        ## Examples

        iex> alias MyspaceIPFS, as: Ipfs
        iex> Ipfs.cat(QmZ4tDuvesekSs4qM5ZBKpXiZGun7S2CYtEZRB3DYXkjGx")
        <<0, 19, 148, 0, ... >>
  """

  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @typep api_error :: MyspaceIPFS.Api.api_error()
  @typep api_response :: MyspaceIPFS.Api.api_response()

  @typedoc """
  This struct is very simple. Some results are listed as "Bytes": bytes, "Hash": hash, "Size": size, "Type": type. This is a
  convenience struct to make it easier match on the result.

  This is returned when you add a file or directory to IPFS.

  I have never seen bytes returned, but it is listed in the docs.
  """
  @type add_result :: MyspaceIPFS.Add.t()

  @typedoc """
  The name of the file or data to be sent to the node. Sometimes you cant't
  use paths, but have to use a cid. This is because prefixes like /ipfs/ or
  /ipns/ are not allowed.

  Not sure how to verify this type.
  """
  @type name :: binary

  @typedoc """
  The name of the file or data to be sent to the node. Sometimes you cant't
  use paths, but have to use a cid. This is because prefixes like /ipfs/ or
  /ipns/ are not allowed.
  """
  @type cid :: binary

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
  The query options to be sent to the node.

  Thi smeans your canæt send tesla: timeout or things like that.
  """
  @type opts :: list

  @typedoc """
  The path to the endpoint to be hit. For example, `/add` or `/cat`.
  It's called path because sometimes the MultiHash is not enough to
  identify the resource, and a path is needed, eg. /ipns/myspace.bahner.com
  """
  @type path :: Path.t()

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
  @spec shutdown() :: :ok
  def shutdown do
    post_query("/shutdown")
    :ok
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
  # FIXME: Path need sto be compile for testing
  @spec resolve(path, opts) :: {:ok, MyspaceIPFS.Path.t()} | api_error
  def resolve(path, opts \\ []),
    do:
      post_query("/resolve?arg=" <> path, query: opts)
      |> okify()

  @doc """
  Add a file to IPFS.

  ## Parameters
  * `fspath` - The file system path to the file or directory to be sent to the node.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-add


  """
  # FIXME return a struct
  @spec add(fspath, opts) :: api_response
  def add(fspath, opts \\ []),
    do:
      multipart(fspath)
      |> post_multipart("/add", query: opts)
      |> MyspaceIPFS.Add.new()
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
  @spec get(path, opts) :: api_response
  defdelegate get(path, opts \\ []), to: MyspaceIPFS.Get

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
  # FIXME: return a struct
  @spec cat(path, opts) :: api_response
  def cat(path, opts \\ []),
    do: post_query("/cat?arg=" <> path, query: opts)

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
  # FIXME: return a struct
  @spec ls(path, opts) :: api_response
  def ls(path, opts \\ []),
    do:
      post_query("/ls?arg=" <> path, query: opts)
      |> MyspaceIPFS.Objects.new()
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
  # FIXME: return a struct
  @spec id :: api_response
  def id,
    do:
      post_query("/id")
      |> okify()

  # |> okify()

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
  # FIXME verify return type
  @spec(ping(pid, peer_id, atom | integer, opts) :: :ignore | {:ok, pid}, {:error, reason})
  def ping(pid, peer, timeout \\ 10, opts \\ []),
    do: MyspaceIPFS.Ping.start_link(pid, peer, timeout, opts)

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
  # FIXME veridy return type
  @spec mount(opts) :: api_response
  def mount(opts \\ []),
    do:
      post_query("/mount", query: opts)
      |> okify()
end
