defmodule ExIpfs do
  @moduledoc """
  Core commands and types for ExIpfs.
  In order for this module to work you need to have an IPFS daemon running. See README.md for details.

        ## Examples

        iex> alias ExIpfs, as: Ipfs
        iex> Ipfs.cat("QmZ4tDuvesekSs4qM5ZBKpXiZGun7S2CYtEZRB3DYXkjGx")
        <<0, 19, 148, 0, ... >>
  """

  require Logger

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
  A struct for the ID returned by the id command.
  """
  @type id :: %ExIpfs.Id{
          addresses: list,
          agent_version: String.t(),
          id: String.t(),
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
  ExIpfs.MultibaseCodec is a struct representing a hash. Seems much like a codec structure to me, but hey. Things may differ.
  """
  @type multi_codec :: %ExIpfs.Multicodec{
          name: binary(),
          code: non_neg_integer()
        }

  @typedoc """
  A Multihash.
  """
  @type multi_hash :: %ExIpfs.Multihash{
          name: binary(),
          code: non_neg_integer()
        }

  @typedoc """
  An object in IPFS with a hash and links to other objects.
  """
  @type object :: %ExIpfs.Object{
          hash: binary(),
          links: list(object())
        }

  # @typedoc """
  # A struct for a hash in the hash links list in Objects.
  # """
  # @type object :: %ExIpfs.Object{
  #         hash: binary(),
  #         name: binary(),
  #         size: non_neg_integer(),
  #         target: binary(),
  #         type: non_neg_integer()
  #       }

  # @typedoc """
  # A struct for the links of hash in Objects.
  # """
  # @type object_links :: %ExIpfs.ObjectLinks{
  #         hash: binary(),
  #         links: list(object())
  #       }

  @typedoc """
  B58 encoded peer ID.
  """
  @type peer_id() :: <<_::48, _::_*8>>

  @doc """
  Resolve the value of names to IPFS.

  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-resolve

  ## Options
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

  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-add

  ## Parameters
  * `fspath` - The file system path to the file or directory to be sent to the node.

  ## Options

  Only options deemed relevant are listed here. See the link above for the full list.
  ```
  [
    chunker: "size-262144", # Chunking algorithm, size-[bytes], rabin-[min]-[avg]-[max] or buzhash
    cid-version: 0, # Defaults to 0 unless an option that depends on CIDv1 is passed. Passing version 1 will cause the raw-leaves option to default to true.
    fscache: true, # Check the filestore for pre-existing blocks. (experimental)
    hash: "sha2-256", # Hash function to use. Implies CIDv1 if not sha2-256. (experimental)
    inline-limit: 32, # Maximum block size to inline. (experimental)
    inline: false, # Inline small blocks into CIDs. (experimental).
    only-hash: false, # Only chunk and hash - do not write to disk.
    pin: true, # Pin locally to protect added files from garbage collection.
    raw-leaves: false, # Use raw blocks for leaf nodes. (experimental)
    to-files: <<>>, #  Add reference to Files API (MFS) at the provided path.
    trickle: false, # Use trickle-dag format for dag generation.
    wrap-with-directory: false, # Wrap files with a directory object.

  ```
  """
  @spec add_fspath(Path.t(), list) :: add_result | ExIpfs.Api.error_response()
  def add_fspath(fspath, opts \\ []),
    do:
      multipart(fspath)
      |> post_multipart("/add", query: opts)
      |> ExIpfs.AddResult.new()
      |> okify()

  @doc """
  Add a file to IPFS.

  ## Parameters
  * `data` - The data to be sent to the IPFS node.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-add


  """
  @spec add(any, list) :: {:ok, add_result()} | ExIpfs.Api.error_response()
  def add(data, opts \\ []),
    do:
      multipart_content(data)
      |> post_multipart("/add", query: opts)
      |> ExIpfs.AddResult.new()
      |> okify()

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
  @spec cat(Path.t(), list) :: {:ok, any} | ExIpfs.Api.error_response()
  def cat(path, opts \\ []),
    do: post_query("/cat?arg=" <> path, query: opts)

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
  # # # @doc """
  # # # Get a file or directory from IPFS.

  # # # *NB! Unsafe (relative symlinks) will raise an error.* This is a limitation of the underlying library.

  # # # ## Options
  # # # https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-get
  # # # ```
  # # # [
  # # #   output: <string>, # Output to file or directory name. Optional, default: <cid-ipfs-or-ipns-path>
  # # #   archive: <bool>, # Output as a tarball. Optional, default: false
  # # #   timeout: <int64>, # Timeout in seconds. Optional, default: 100
  # # # ]
  # # # ```
  # # # Compression is not implemented.

  # # # If you feel that you need more timeouts, you can use the `:timeout` option in the `opts` list.
  # # # But the default should be enough for most cases. More likely your content isn't available....
  # # # """
  # # # @spec get(Path.t(), list) :: {:ok, Path.t()} | ExIpfs.Api.error_response()
  # # # defdelegate get(path, opts \\ []), to: ExIpfs.Get

  @doc """
  Show the id of the IPFS node.

  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-id
  Returns a map with the following keys:
    - ID: the id of the node.
    - PublicKey: the public key of the node.
    - Addresses: the addresses of the node.
    - AgentVersion: the version of the node.
    - Protocols: the protocols of the node.
  """
  @spec id :: {:ok, id()} | ExIpfs.Api.error_response()
  def id,
    do:
      post_query("/id")
      |> ExIpfs.Id.new()
      |> okify()

  @doc """
  List directory contents for Unix filesystem objects in IPFS.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-ls
  ```
  [
    headers: <bool>, # Print table headers (Hash, Size, Name). Optional, default: false
    resolve-type: <bool>, # Resolve linked objects to find out their types. Optional, default: false
    timeout: <int64>, # Timeout in seconds. Optional, default: 100
  ]
  ```

  Streaming is not supported yet, but might be in there future. Post a feature request if you need it.
  """
  @spec ls(Path.t(), list) :: {:ok, list(object())} | ExIpfs.Api.error_response()
  def ls(path, opts \\ []) do
    with %{"Objects" => objects} <- post_query("/ls?arg=" <> path, query: opts) do
      {:ok, Enum.map(objects, &ExIpfs.Object.new(&1))}
    end
  end

  # |> ExIpfs.Objects.new()
  # |> okify()

  @doc """
  Ping a peer in the IPFS network.

  """
  # coveralls-ignore-start
  # We don't have anything to ping. So we can't test this.
  @spec ping(peer_id, pid, atom | integer, list) :: :ignore | {:error, any} | {:ok, pid}
  def ping(peer_id, pid \\ self(), timeout \\ :infinity, opts \\ []) do
    request = ExIpfs.PingRequest.new(peer_id, pid, timeout, opts)
    ExIpfs.Ping.new(request)
  end

  # coveralls-ignore-stop
end
