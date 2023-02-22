defmodule ExIpfs.Refs do
  @moduledoc """
  ExIpfs.Refs is where the main commands of the IPFS API reside.
  """

  import ExIpfs.Api
  import ExIpfs.Utils

  defstruct [
    :Ref,
    :Err
  ]

  @typedoc """
    Type for the response of entries in the refs list.

    ## Options
    https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-refs
  """

  @doc """
  Get a list of all local references.

  Response is a list of Refs.t().
  """
  @spec local :: {:ok, ExIpfs.ref()} | ExIpfs.Api.error_response()
  def local,
    do:
      post_query("/refs/local")
      |> Enum.map(&ExIpfs.Ref.new/1)
      |> okify()

  @doc """
  Get a list of all references from a given path.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-refs
  """
  # This is not suitable for unit testing.
  # coveralls-ignore-start
  @spec refs(Path.t(), list()) :: {:ok, any} | ExIpfs.Api.error_response()
  def refs(path, opts \\ []),
    do:
      post_query("/refs?arg=" <> path, query: opts)
      |> okify()

  # coveralls-ignore-stop
end
