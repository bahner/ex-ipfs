defmodule MyspaceIpfs.Config do
  @moduledoc """
  MyspaceIpfs.Config is where the config commands of the IPFS API reside.
  """
  import MyspaceIpfs.Api
  import MyspaceIpfs.Utils

  @typep name :: MyspaceIpfs.name()
  @typep result :: MyspaceIpfs.result()
  @typep opts :: MyspaceIpfs.opts()
  @typep fspath :: MyspaceIpfs.fspath()

  @doc """
  Get the value of a config key.

  ## Parameters
  key: The key to get the value of.
  value: the value to set the key to (optional).

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-config
  ```
  [
    "bool" - <bool>, # Set a boolean value.
    "json" - <bool>, # Parse stringified JSON.
  ]
  ```
  """
  @spec config(name, name, opts) :: result
  def config(key, value \\ nil, opts \\ [])

  def config(key, value, opts) when is_bitstring(key) and is_bitstring(value) do
    post_query("/config?arg=" <> key <> "&arg=" <> value, query: opts)
    |> handle_api_response()
    |> okify()
  end

  def config(key, value, opts) when is_bitstring(key) and is_nil(value) do
    post_query("/config?arg=" <> key, query: opts)
    |> handle_api_response()
    |> okify()
  end

  def config(key, _value, opts) when is_bitstring(key) and is_list(opts) do
    post_query("/config?arg=" <> key, query: opts)
    |> handle_api_response()
    |> okify()
  end

  @doc """
  Apply profile to config.

  ## Parameters
  profile: The profile to apply.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-config-profile-apply
  ```
  [
    `dry-run` - <bool>, # Dry run.
  ]
  ```
  """
  @spec profile_apply(name, opts) :: result
  def profile_apply(profile, opts \\ []) when is_bitstring(profile) do
    post_query("/config/profile/apply?arg=" <> profile, query: opts)
    |> handle_api_response()
    |> okify()
  end

  @doc """
  Replace the config with the given JSON file.

  ## Parameters
  fspath: The path to the config file to use.
  """
  @spec replace(fspath) :: result
  def replace(fspath) do
    multipart(fspath)
    |> post_multipart("/config/replace")
    |> handle_api_response()
    |> okify()
  end

  @doc """
  Show the current config.
  """
  @spec show() :: result
  def show() do
    post_query("/config/show")
    |> handle_api_response()
    |> okify()
  end
end
