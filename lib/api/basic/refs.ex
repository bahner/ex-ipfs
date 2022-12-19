defmodule MyspaceIPFS.Api.Basic.Refs do
  @moduledoc """
  MyspaceIPFS.Api is where the main commands of the IPFS API reside.
  """

  import MyspaceIPFS

  @type multipart :: Tesla.Multipart.t() | binary
  @type result :: MyspaceIPFS.result

  @doc """
  Get a list of all local references.
  """
  def local,
    do:
      post_query_plain("/refs/local")
      |> extract_refs()

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
  def refs(cid, opts \\ [] ) do

    path = "/refs?arg=" <> cid

    extract_refs(post_query_plain(path, query: opts))
  end

  # For now the easiest part is to just filter out the meta words,
  # in order to get the refs.
  defp is_allowed_ref(word) do
    meta_chars = ["Ref", "u003e", "Err"]

    if word in meta_chars do
      false
    else
      true
    end
  end

  # Extract only the words from the list, that are allowed refs.
  defp extract_refs_from_list(list) do
    list
    |> Enum.filter(fn x -> is_allowed_ref(x) end)
  end

  def extract_return_elements?(list) do
    # If we have edges we need to convert the list to a tuple
    # otherwise just return the element.
    if Enum.at(list, 1) == nil do
      Enum.at(list, 0)
    else
      List.to_tuple(list)
    end
  end

  defp filter_list(list) do
    list
    |> Enum.filter(fn x -> x != nil end)
    |> Enum.filter(fn x -> x != {} end)
    |> Enum.filter(fn x -> x != [] end)
  end

  defp extract_refs(input) do
    with {:ok, binary} <- input do
      binary
        # Each result is a line.
        |> String.split("\n")
        # Extract a list of all the words in each line.
        |> Enum.map(fn x -> Regex.scan(~r/\w+/, x) end)
        # Now flatten the list, so we only have one list per line
        |> Enum.map(fn x -> List.flatten(x) end)
        # Extract the refs from the list.
        |> Enum.map(fn x -> extract_refs_from_list(x) end)
        # Convert the list to a tuple if needed.
        |> Enum.map(fn x -> extract_return_elements?(x) end)
        # # Remove empty tuples or elements.
        |> filter_list()
        |> (fn x -> {:ok, x} end).()
    else
      input -> input
    end
  end
end
