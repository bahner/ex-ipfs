defmodule MyspaceIPFS.Api.Basic.Refs do
  @moduledoc """
  MyspaceIPFS.Api is where the main commands of the IPFS API reside.
  """

  import MyspaceIPFS
  import MyspaceIPFS.Utils

  @type multipart :: Tesla.Multipart.t() | binary
  @type result :: MyspaceIPFS.result()

  @doc """
  Get a list of all local references.
  """
  def local,
    do:
      post_query("/refs/local")
      |> map_plain_response_data()

  @doc """
  Get a list of all references from a given object.

  Return a list of tuples. Only one element without edges, but two
  for edges. The first element is the source, the second is the
  destination.

  This way it is easy to match on the result.

  # Parameters
  multihash: The hash or IPNS name of the object to list references from.
  opts: A list of options.

  ## opts
  opts is a list of tuples that can contain the following values:
  - `format`: The format in which the output should be returned.
    Allowed values are `<dst>`, `<src>` and `<linkname>`a.
  - `edges`: If true, the output will contain edge objects.
  - `unique`: If true, the output will contain unique objects.
  - `recursive`: If true, the output will contain recursive objects.
  - `max_depth`: The maximum depth of the output.
  """
  # @spec refs(binary) :: {:ok, list} | {:error, binary}
  # @spec refs(binary, list) :: {:ok, list} | {:error, binary}
  @spec refs(binary, list) :: {:ok, list} | result
  def refs(cid, opts \\ []) do
    path = "/refs?arg=" <> cid

    post_query(path, query: opts)
    # |> map_plain_response_data()
  end
end
