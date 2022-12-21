defmodule MyspaceIPFS.Api.Basic.Refs do
  @moduledoc false
  # @moduledoc """
  # MyspaceIPFS.Api is where the main commands of the IPFS API reside.
  # """

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
  def local,do:
    post_query("/refs/local")
    |> map_response_data()

  @spec refs(path, opts) :: mapped
  def refs(path, opts \\ []), do:
    path = "/refs?arg=" <> path

    post_query(path, query: opts)
    |> map_response_data()
end
