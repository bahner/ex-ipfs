defmodule ExIpfs do
  @moduledoc """
  ExIpfs is where the main commands of the IPFS API reside.
  Alias this library and you can run the commands via Api.<cmd_name>.

        ## Examples

        iex> alias ExIpfs, as: Ipfs
        iex> Ipfs.cat(QmZ4tDuvesekSs4qM5ZBKpXiZGun7S2CYtEZRB3DYXkjGx")
        <<0, 19, 148, 0, ... >>
  """

  import ExIpfs.Api
  import ExIpfs.Utils

  @typedoc """
  A struct that represents the result of adding a file to IPFS.
  """
  @type add_result :: %ExIpfs.AddResult{
          bytes: non_neg_integer(),
          hash: binary(),
          name: binary(),
          size: non_neg_integer()
        }

  @typedoc """
  A struct for a hash in the hash links list in Objects.
  """
  @type hash :: %ExIpfs.Hash{
          hash: binary(),
          name: binary(),
          size: non_neg_integer(),
          target: binary(),
          type: non_neg_integer()
        }

  @typedoc """
  A struct for the links of hash in Objects.
  """
  @type hash_links :: %ExIpfs.HashLinks{
          hash: binary(),
          links: list(hash())
        }

  @typedoc """
  A struct for the ID returned by the id command.
  """
  @type id :: %ExIpfs.Id{
          addresses: list,
          agent_version: String.t(),
          id: String.t(),
          protocol_version: String.t(),
          public_key: String.t(),
          protocols: list
        }

  @typedoc """
  This struct is very simple. Some results are listed as "Value": size. This is a
  convenience struct to make it easier match on the result.
  """
  @type key_value :: %ExIpfs.KeyValue{key: binary(), value: binary()}

  @typedoc """
  A struct for the links of a DAG in IPLD. When IPLD sees such a Key Value in the JSON result it will lookup the data.
  """
  @type link :: %ExIpfs.Link{/: binary()}

  @typedoc """
  Results when mounting IPFS in a FUSE filesystem.
  """
  @type mount_result :: %ExIpfs.MountResult{
    fuse_allow_other: boolean(),
    ipfs: binary(),
    ipns: binary(),
  }

  @typedoc """
  ExIpfs.MultibaseCodec is a struct representing a hash. Seems much like a codec structure to me, but hey. Things may differ.
  """
  @type multi_codec :: %ExIpfs.Multicodec{
          name: binary(),
          code: non_neg_integer()
        }

  @typedoc """
  A multihash.
  """
  @type multi_hash :: %ExIpfs.MultiHash{
          name: binary(),
          code: non_neg_integer()
        }

  @typedoc """
  A struct that represents the objects in IPFS.
  """
  @type objects :: %ExIpfs.Objects{objects: list(hash_links())}

  @typedoc """
  B58 encoded peer ID.
  """
  @type peer_id() :: <<_::48, _::_*8>>

  @typedoc """
  A struct for list of peers in the network.
  """
  @type peers :: %ExIpfs.Peers{
          peers: list | nil
        }

  @typedoc """
  A struct when IPFS API returns a list of strings.
  """
  @type strings :: %ExIpfs.Strings{strings: list(binary())}
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
  @spec resolve(Path.t(), list) :: {:ok, Path.t()} | ExIpfs.Api.error_response()
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
  @spec add_fspath(Path.t(), list) :: {:ok, add_result()} | ExIpfs.Api.error_response()
  def add_fspath(fspath, opts \\ []),
    do:
      multipart(fspath)
      |> post_multipart("/add", query: opts)
      |> ExIpfs.AddResult.new()
      |> okify()

  @doc """
  Add a file to IPFS.

  ## Parameters
  * `fspath` - The file system path to the file or directory to be sent to the node.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-add


  """
  # FIXME return a struct
  @spec add(any, list) :: {:ok, add_result()} | ExIpfs.Api.error_response()
  def add(data, opts \\ []),
    do:
      multipart_content(data)
      |> post_multipart("/add", query: opts)
      |> ExIpfs.AddResult.new()
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
  @spec get(Path.t(), list) :: {:ok, Path.t()} | ExIpfs.Api.error_response()
  defdelegate get(path, opts \\ []), to: ExIpfs.Get

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
  @spec cat(Path.t(), list) :: {:ok, any} | ExIpfs.Api.error_response()
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
  @spec ls(Path.t(), list) :: {:ok, objects()} | ExIpfs.Api.error_response()
  def ls(path, opts \\ []),
    do:
      post_query("/ls?arg=" <> path, query: opts)
      |> ExIpfs.Objects.new()
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
  @spec id :: {:ok, id()} | ExIpfs.Api.error_response()
  def id,
    do:
      post_query("/id")
      |> ExIpfs.Id.new()
      |> okify()

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
  @spec mount(list) :: {:ok, any} | ExIpfs.Api.error_response()
  def mount(opts \\ []),
    do:
      post_query("/mount", query: opts)
      |> okify()
end
