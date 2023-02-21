defmodule ExIPFS.Key do
  @moduledoc """
  ExIPFS.Key is where the key commands of the IPFS API reside.
  """
  import ExIPFS.Api
  import ExIPFS.Utils

  # @doc """
  # Export a keypair.

  # ## Parameters
  #   `key` - Name of the key to export.
  #   `output` - Output file path or :memory.
  #             :memory just returns the key as a binary.

  # ## Options
  # https://docs.ipfs.io/reference/http/api/#api-v0-key-export
  # ```
  # [
  #   format: <string>, # Key format.
  # ]
  # ```
  # """
  # @spec export(binary(), Path.t() | atom, list()) :: {:ok, any} | ExIPFS.Api.error_response()
  # def export(key, output \\ :memory, opts \\ []) do
  #   key = post_query("/key/export?arg=" <> key, query: opts)

  #   case output do
  #     :memory -> okify(key)
  #     _ -> File.write(output, key)
  #   end
  # end

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
  @spec gen(binary(), list()) :: {:ok, any} | ExIPFS.Api.error_response()
  def gen(key, opts \\ []) do
    post_query("/key/gen?arg=" <> key, query: opts)
    |> okify()
  end

  @doc """
  Import a key and prints imported key id.

  ## Parameters
  `key` - Name of the key to import.
  `name` - Name of the key to import.

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
  @spec import(binary(), binary(), list()) :: {:ok, any} | ExIPFS.Api.error_response()
  def import(key, name, opts \\ []) do
    multipart_content(key)
    |> post_multipart("/key/import?arg=" <> name, query: opts)
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
  @spec list(list()) :: {:ok, any} | ExIPFS.Api.error_response()
  def list(opts \\ []) do
    post_query("/key/list", query: opts)
    |> okify()
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
  @spec rename(binary(), binary(), list()) :: {:ok, any} | ExIPFS.Api.error_response()
  def rename(old, new, opts \\ []) do
    post_query("/key/rename?arg=" <> old <> "&arg=" <> new, query: opts)
    |> okify()
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
  @spec rm(binary(), list()) :: {:ok, any} | ExIPFS.Api.error_response()
  def rm(key, opts \\ []) do
    post_query("/key/rm?arg=" <> key, query: opts)
    |> okify()
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
  @spec rotate(binary(), list()) :: {:ok, any} | ExIPFS.Api.error_response()
  def rotate(oldkey, opts \\ []) do
    post_query("/key/rotate?arg=" <> oldkey, query: opts)
    |> okify()
  end
end
