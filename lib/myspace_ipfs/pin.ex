defmodule MyspaceIPFS.Pin do
  @moduledoc """
  MyspaceIPFS.Pin is where the pin commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @type okmapped :: MySpaceIPFS.okmapped()
  @type name :: MySpaceIPFS.name()
  @type opts :: MySpaceIPFS.opts()
  @type path :: MySpaceIPFS.path()
  @type url :: Tesla.Env.url()

  ### Local Pinning

  @doc """
  Add an IPFS object to the pinset.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-pin-add
  ```
  [
    recursive: <bool>, # Recursively pin the object linked to by the specified object(s). Default: true
    timeout: <string>, # Maximum time to wait for the command to complete. Default: 1m0s
  ]
  ```
  """
  @spec add(path) :: okmapped()
  def add(path), do: post_query("/pin/add?arg=" <> path)

  @doc """
  List objects pinned to local storage.

  ## Parameters
  `path` - The path of the object to list pins for. Default: `nil`

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-pin-ls
  ```
  [
    type: <string>, # The type of pinned keys to list. Can be "direct", "indirect", "recursive", "all". Default: "all"
    quiet: <bool>, # Write just hashes of objects. Default: false
    stream: <bool>, # Stream output of pins as they are found. Default: false
  ]
  ```
  """
  @spec ls(path) :: okmapped()
  def ls(path) do
    post_query("/pin/ls?arg=" <> path)
    |> handle_plain_response()
  end

  @doc """
  List objects pinned to local storage.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-pin-ls
  ```
  [
    type: <string>, # The type of pinned keys to list. Can be "direct", "indirect", "recursive", "all". Default: "all"
    quiet: <bool>, # Write just hashes of objects. Default: false
    stream: <bool>, # Stream output of pins as they are found. Default: false
  ]
  ```
  """
  @spec ls() :: okmapped
  def ls() do
    post_query("/pin/ls")
    |> handle_plain_response()
  end

  @doc """
  Remove an IPFS object from the pinset.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-pin-rm
  ```
  [
    recursive: <bool>, # Recursively unpin the object linked to by the specified object(s). Default: true
  ]
  ```
  """
  @spec rm(path) :: okmapped()
  def rm(path) do
    post_query("/pin/rm?arg=" <> path)
    |> handle_plain_response()
  end

  @doc """
  Update a recursive pin to a direct pin.

  ## Parameters
  `old` - The path of the old object.
  `new` - The path of the new object to pin.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-pin-update
  ```
  [
    unpin: <bool>, # Unpin the object when changing. Default: true
  ]
  ```
  """
  @spec update(path, path, opts) :: okmapped
  def update(old, new, opts \\ []) do
    post_query("/pin/update?arg=" <> old <> "&arg=" <> new, query: opts)
    |> handle_plain_response()
  end

  @doc """
  Verify that recursive pins are complete.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-pin-verify
  ```
  [
    verbose: <bool>, # Print extra information. Default: false
  ]
  ```
  """
  @spec verify(opts) :: okmapped
  def verify(opts \\ []) do
    post_query("/pin/verify", query: opts)
    |> handle_plain_response()
  end

  ### Remote Pinning

  @doc """
  Add a local object to the cluster pinset.

  ## Parameters
  `path` - The path of the object to list pins for.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-pin-remote-add
  ```
  [
    name: <string>, # Optional name for the pin.
    background: <bool>, # Pin in the background. Default: false
    service: <string>, # The name of the remote pinning service to use.
  ]
  ```
  """
  @spec remote_add(path, opts) :: okmapped
  def remote_add(path, opts \\ []) do
    post_query("/pin/remote/add?arg=" <> path, query: opts)
    |> handle_plain_response()
  end

  @doc """
  List objects pinned to remote storage.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-pin-ls
  ```
  [
    service: <string>, # The name of the remote pinning service to use.
    name: <string>, # The name of the remote pinset to list.
    cid: <array>, # Comma separated list of CIDs to list.
    status: <array>, # Comma separated list of statuses to filter by.
                      Default: "pinned"
                      Allowed: "queued", "pinning", "pinned", "failed"
  ]
  ```
  """
  @spec remote_ls(opts) :: okmapped
  def remote_ls(opts \\ []) do
    post_query("/pin/remote/ls", query: opts)
    |> handle_plain_response()
  end

  @doc """
  Remove pins from a remote pinset.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-pin-remote-rm
  ```
  [
    service: <string>, # The name of the remote pinning service to use.
    name: <string>, # The name of the remote pinset to remove pins from. Case sensitive and exact match.
    cid: <array>, # Comma separated list of CIDs to remove.
    status: <array>, # Comma separated list of statuses to filter by.
                      Default: "pinned"
                      Allowed: "queued", "pinning", "pinned", "failed"
    force: <bool>, # Force removal of pins that are not in the specified status. Default: false
  ]
  ```
  """
  @spec remote_rm(opts) :: okmapped
  def remote_rm(opts \\ []) do
    post_query("/pin/remote/rm", query: opts)
    |> handle_plain_response()
  end

  ### Remote Pinning Services

  @doc """
  Add a service endpoint to the cluster.

  *You should probably not use this, unless you are using the default API on localhost, since your AUTH token is shared.*

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-pin-remote-service-add
  ```
  [
    endpoint: <string>, # Endpoint to add to the cluster.
    name: <string>, # Name of the endpoint.
    key: <string>, # Key to use for the endpoint.
  ]
  ```
  """
  @spec remote_service_add(binary, url, binary) :: okmapped
  def remote_service_add(service, endpoint, key) do
    post_query("/pin/remote/service/add?arg=" <> service <> "&arg=" <> endpoint <> "&arg=" <> key)
    |> handle_plain_response()
  end

  @doc """
  List service endpoints in the cluster.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-pin-remote-service-ls
  ```
  [
    stat: <bool>, # Show extra information about the services. Default: false
  ]
  ```
  """
  @spec remote_service_ls(opts) :: okmapped
  def remote_service_ls(opts \\ []) do
    post_query("/pin/remote/service/ls", query: opts)
    |> handle_plain_response()
  end

  @doc """
  Remove a service endpoint from the cluster.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-pin-remote-service-rm
  ```
  [
    endpoint: <string>, # Endpoint to add to the cluster. Default: ""
    name: <string>, # Name of the endpoint. Default: ""
  ]
  ```
  """
  @spec remote_service_rm(name) :: okmapped
  def remote_service_rm(service) do
    post_query("/pin/remote/service/rm?arg=" <> service)
    |> handle_plain_response()
  end
end
