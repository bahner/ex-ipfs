defmodule MyspaceIpfs.Refs do
  @moduledoc """
  MyspaceIpfs.Refs is where the main commands of the IPFS API reside.
  """

  import MyspaceIpfs.Api
  import MyspaceIpfs.Utils

  defstruct [
    :Ref,
    :Err
  ]

  @typedoc """
    Type for the response of entries in the refs list.

    ## Options
    https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-refs
  """
  @type t :: %__MODULE__{
          Ref: String.t(),
          Err: String.t()
        }

  @typep okmapped :: MyspaceIpfs.okmapped()
  @typep opts :: MyspaceIpfs.opts()
  @typep path :: MyspaceIpfs.path()

  @doc """
  Get a list of all local references.

  Response is a list of Refs.t().
  """
  @spec local :: okmapped
  def local,
    do:
      post_query("/refs/local")
      |> okify()

  @doc """
  Get a list of all references from a given path.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-refs
  """
  @spec refs(path, opts) :: okmapped
  def refs(path, opts \\ []),
    do:
      post_query("/refs?arg=" <> path, query: opts)
      |> okify()
end
