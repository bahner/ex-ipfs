defmodule MyspaceIPFS.Key do
  @moduledoc """
  MyspaceIPFS.Api is where the key commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @typep okresult :: MyspaceIPFS.okresult()
  @typep opts :: MyspaceIPFS.opts()
  @typep name :: MyspaceIPFS.name()
  @typep fspath :: MyspaceIPFS.fspath()

  @doc """
  Export a keypair.

  ## Parameters
    `key` - Name of the key to export.
    `output` - Output file path.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-key-export
  ```
  [
    output: <string>, # Output file path.
    format: <string>, # Key format.
  ]
  ```
  """
  @spec export(name, fspath, opts) :: okresult
  def export(key, output, opts \\ []) do
    post_query("/key/export?arg=" <> key, query: opts)
    |> handle_file_response(output)
  end

  @doc """
  Create a new keypair.

  ## Parameters
    `key` - Name of the key to generate.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-key-gen
  ```
  [
    type: <string>, # Key type.
    size: <int>, # Key size.
    ipns-base: <string>, # IPNS key base.
  ]
  ```
  """
  @spec gen(name, opts) :: okresult
  def gen(key, opts \\ []) do
    post_query("/key/gen?arg=" <> key, query: opts)
    |> handle_json_response()
  end

  @doc """
  Import a key and prints imported key id.

  ## Parameters
    `key` - Name of the key to import.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-key-import
  ```
  [
    ipns-base: <string>, # IPNS key base.
    format: <string>, # Key format.
    allow-any-key-type: <bool>, # Allow any key type.
  ]
  ```
  """
  @spec import(name, fspath, opts) :: okresult
  def import(key, file, opts \\ []) do
    post_file("/key/import?arg=" <> key, file, query: opts)
    |> handle_json_response()
  end

  @doc """
  List all local keypairs.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-key-list
  ```
  [
    l: <bool>, # Show extra information.
    ipns-base: <string>, # IPNS key base.
  ]
  ```
  """
  @spec list(opts) :: okresult
  def list(opts \\ []) do
    post_query("/key/list", query: opts)
    |> handle_json_response()
  end

  @doc """
  Rename a keypair.

  ## Parameters
    `old` - Name of the key to rename.
    `new` - New name of the key.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-key-rename
  ```
  [
    ipns-base: <string>, # IPNS key base.
    force: <bool>, # Allow to overwrite existing key.
  ]
  ```
  """
  @spec rename(name, name, opts) :: okresult
  def rename(old, new, opts \\ []) do
    post_query("/key/rename?arg=" <> old <> "&arg=" <> new, query: opts)
    |> handle_json_response()
  end

  @doc """
  Remove a keypair.

  ## Parameters
    `key` - Name of the key to remove.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-key-rm
  ```
  [
    ipns-base: <string>, # IPNS key base.
    l: <bool>, # Show extra information.
  ]
  ```
  """
  @spec rm(name, opts) :: okresult
  def rm(key, opts \\ []) do
    post_query("/key/rm?arg=" <> key, query: opts)
    |> handle_json_response()
  end

  @doc """
  Rotate a keypair.

  ## Parameters
    `oldkey` - Keystore name for backing up the old key.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-key-rotate
  ```
  [
    type: <string>, # Key type.
    size: <int>, # Key size.
  ]
  ```
  """
  @spec rotate(name, opts) :: okresult
  def rotate(oldkey, opts \\ []) do
    post_query("/key/rotate?arg=" <> oldkey, query: opts)
    |> handle_plain_response()
  end
end
