defmodule MyspaceIPFS.Name do
  @moduledoc """
  MyspaceIPFS.Name is where the name commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @typep okresult :: MyspaceIPFS.okresult()
  @typep path :: MyspaceIPFS.path()
  @typep opts :: MyspaceIPFS.opts()

  @doc """
  Publish IPNS names.

  ## Parameters
    `path` - Path to be published.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-name-publish
  ```
  [
    resolve: <bool>, # Resolve given path before publishing.
    lifetime: <string>, # Time duration that the record will be valid for.
    allow-offline: <bool>, # Run offline.
    ttl: <string>, # Time duration this record should be cached for (caution: experimental).
    key: <string>, # Name of the key to be used or a valid PeerID, as listed by 'ipfs key list -l'.
    quieter: <bool>, # Write minimal output.
    ipns-base: <string>, # IPNS key base.
  ]
  ```
  """
  @spec publish(path, opts) :: okresult
  def publish(path, opts \\ []),
    do:
      post_query("/name/publish?arg=" <> path, query: opts)
      |> handle_json_response()

  @doc """
  Resolve IPNS names.

  ## Parameters
    `name` - IPNS name to resolve.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-name-resolve
  ```
  [
    recursive: <bool>, # Resolve until the result is not an IPNS name.
    nocache: <bool>, # Do not use cached entries.
    dht-record-count: <int>, # Number of records to request for DHT resolution.
    dht-timeout: <string>, # Maximum time to collect values during DHT resolution eg "30s".
    stream: <bool>, # Stream the output as a continuous series of JSON values.
  ]
  ```
  """
  @spec resolve(path, opts) :: okresult
  def resolve(path, opts \\ []),
    do:
      post_query("/name/resolve?arg=" <> path, query: opts)
      |> handle_json_response()
end
