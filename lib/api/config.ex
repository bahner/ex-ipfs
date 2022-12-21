defmodule MyspaceIPFS.Api.Config do
  @moduledoc """
  MyspaceIPFS.Api is where the main commands of the IPFS API reside.
  """
  import MyspaceIPFS

  @type name :: MyspaceIPFS.name()
  @type result :: MyspaceIPFS.result()
  @type opts :: MyspaceIPFS.opts()
  @type path :: MyspaceIPFS.path()

  @doc """
  Get the value of a config key.

  ## Parameters
  key: The key to get the value of.
  value: the value to set the key to (optional).
  opts: The options to pass to the command (optional).

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-config
  ```
  [
    arg: "<string>", # the value of the key to set
    bool: "<bool>",
    file: "<string>",
    json: "<bool>",
  ]
  ```
  """
  @spec config(name, name, opts) :: result
  @spec config(name, opts) :: result
  def config(key, value \\ nil, opts \\ [])

  def config(key, value, opts) when is_bitstring(key) and is_bitstring(value) do
    post_query("/config?arg=" <> key <> "&arg=" <> value, opts)
    |> map_response_data()
  end

  def config(key, value, opts) when is_bitstring(key) and is_nil(value) do
    post_query("/config?arg=" <> key, opts)
    |> Jason.decode()
  end

  def config(key, _value, opts) when is_bitstring(key) and is_list(opts) do
    post_query("/config?arg=" <> key, opts)
    |> Jason.decode()
  end

  def show(args) when is_bitstring(args) do
    {:ok, res} = post_query("/update?arg=", args)
    res.body |> String.replace(~r/\r|\n/, "")
  end

  # version function - does not currently accept the optional arguments on golang client.
  def version(num \\ false, comm \\ false, repo \\ false, all \\ false) do
    post_query(
      "/version?number=" <>
        to_string(num) <>
        "&commit=" <> to_string(comm) <> "&repo=" <> to_string(repo) <> "&all=" <> to_string(all),
      ""
    )
  end
end
