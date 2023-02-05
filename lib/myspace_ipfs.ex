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

  @typedoc """
  A struct that represents the result of adding a file to IPFS.
  """
  @type add_result :: %MyspaceIPFS.AddResult{
          bytes: non_neg_integer(),
          hash: binary(),
          name: binary(),
          size: non_neg_integer()
        }

  @typedoc """
  A struct for a hash in the hash links list in Objects.
  """
  @type hash :: %MyspaceIPFS.Structs.Hash{
          hash: binary(),
          name: binary(),
          size: non_neg_integer(),
          target: binary(),
          type: non_neg_integer()
        }

  @typedoc """
  A struct for the links of hash in Objects.
  """
  @type hash_links :: %MyspaceIPFS.Structs.HashLinks{
          hash: binary(),
          links: list(hash())
        }

  @typedoc """
  This struct is very simple. Some results are listed as "Value": size. This is a
  convenience struct to make it easier match on the result.
  """
  @type key_value :: %MyspaceIPFS.Structs.KeyValue{key: binary(), value: binary()}

  @typedoc """
  MyspaceIPFS.MultibaseCodec is a struct representing a hash. Seems much like a codec structure to me, but hey. Things may differ.
  """
  @type multi_codec :: %MyspaceIPFS.Structs.MultiCodec{
          name: binary(),
          code: non_neg_integer()
        }

  @typedoc """
  A multihash.
  """
  @type multi_hash :: %MyspaceIPFS.Structs.MultiHash{
          name: binary(),
          code: non_neg_integer()
        }

  @typedoc """
  A struct that represents the objects in IPFS.
  """
  @type objects :: %MyspaceIPFS.Structs.Objects{objects: list(hash_links())}

  @typedoc """
  B58 encoded peer ID.
  """
  @type peer_id() :: <<_::48, _::_*8>>

  @typedoc """
  A struct for list of peers in the network.
  """
  @type peers :: %MyspaceIPFS.Structs.Peers{
          peers: list | nil
        }

  @typedoc """
  A struct when IPFS API returns a list of strings.
  """
  @type strings :: %MyspaceIPFS.Structs.Strings{strings: list(binary())}

  @typedoc """
  This struct is very simple. Some results are listed as `%{"/": cid}`. This is a
  convenience struct to make it easier match on the result.

  The name is odd, but it signifies that it is a CID of in the API notation, with the
  leading slash. It is used for the root of a tree.
  """
  @type slash_cid :: %MyspaceIPFS.Structs.SlashCID{/: binary}

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
  @spec daemon(boolean, atom, list) :: pid
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
  @spec resolve(Path.t(), list) :: {:ok, Path.t()} | MyspaceIPFS.Api.error_response()
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
  @spec add(Path.t(), list) :: {:ok, add_result()} | MyspaceIPFS.Api.error_response()
  def add(fspath, opts \\ []),
    do:
      multipart(fspath)
      |> post_multipart("/add", query: opts)
      |> MyspaceIPFS.AddResult.new()
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
  @spec get(Path.t(), list) :: {:ok, Path.t()} | MyspaceIPFS.Api.error_response()
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
  @spec cat(Path.t(), list) :: {:ok, any} | MyspaceIPFS.Api.error_response()
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
  @spec ls(Path.t(), list) :: {:ok, objects()} | MyspaceIPFS.Api.error_response()
  def ls(path, opts \\ []),
    do:
      post_query("/ls?arg=" <> path, query: opts)
      |> MyspaceIPFS.Structs.Objects.new()
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
  @spec id :: {:ok, map} | MyspaceIPFS.Api.error_response()
  def id,
    do:
      post_query("/id")
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
  # FIXME verify return type
  @spec(
    ping(pid, MyspaceIPFS.peer_id(), atom | integer, list) :: :ignore | {:ok, pid},
    {:error, reason}
  )
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
  @spec mount(list) :: {:ok, any} | MyspaceIPFS.Api.error_response()
  def mount(opts \\ []),
    do:
      post_query("/mount", query: opts)
      |> okify()
end
