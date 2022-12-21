defmodule MyspaceIPFS.Api.Basic.Refs do
  @moduledoc """
  MyspaceIPFS.Api is where the main commands of the IPFS API reside.
  """

  import MyspaceIPFS

  defstruct [
    :Ref,
    :Err
  ]

  @typedoc """
    Type for the response of entries in the refs list.
  """
  @type t :: %__MODULE__{
          Ref: String.t(),
          Err: String.t()
        }

  @typep mapped :: MyspaceIPFS.plain()
  @typep opts :: MyspaceIPFS.opts()
  @typep path :: MyspaceIPFS.path()

  @doc """
  Get a list of all local references.

  Response is a list of Refs.t().
  """
  @spec local :: mapped
  def local,
    do: post_query("/refs/local")

  @doc """
  Get a list of all references from a given object.

  Response is a list of Refs.t().

  # Parameters
  path: The IPFS path name of the object to list references from.
  opts: A list of options.

  ## opts
  # https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-refs
  Options are passed as a list of maps with the following format:
  [format: "<string>", edges: <bool>, unique: <bool>, recursive: <bool>, max-depth: <int>]
  """
  @spec refs(path, opts) :: mapped
  def refs(path, opts \\ []) do
    path = "/refs?arg=" <> path

    post_query(path, query: opts)
  end
end
