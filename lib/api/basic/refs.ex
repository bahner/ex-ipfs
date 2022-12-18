defmodule MyspaceIPFS.Api.Basic.Refs do
  @moduledoc """
  MyspaceIPFS.Api is where the main commands of the IPFS API reside.
  """

  import MyspaceIPFS

  @type multipart :: Tesla.Multipart.t() | binary

  @doc """
  Get a list of all local references.
  """
  @spec local :: list
  def local,
    do:
      post_query_plain("/refs/local")
      |> extract_refs()

  @doc """
  Get a list of all references from a given object.

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
  def refs(
        multihash,
        opts \\ []
      )
      when is_binary(multihash) and
             is_list(opts) do
    path = "/refs?arg=" <> multihash

    extract_refs(post_query_plain(path, query: opts))
  end

  defp is_allowed_ref(word) do
    meta_chars = ["Ref", "u003e", "Err"]

    if word in meta_chars do
      false
    else
      true
    end
  end

  defp extract_refs_from_list(list) do
    list
    |> Enum.filter(fn x -> is_allowed_ref(x) end)
  end

  defp extract_refs(binary) do
    binary
    # Each result is a line.
    |> String.split("\n")
    # Extract a list of all thge words in each line.
    |> Enum.map(fn x -> Regex.scan(~r/\w+/, x) end)
    # Now flatten the list, so we only have one list per line
    |> Enum.map(fn x -> List.flatten(x) end)
    # Extract the refs from the list.
    |> Enum.map(fn x -> extract_refs_from_list(x) end)
    # Convert each line to a tuple. Each tuple may contain multiple refs.
    |> Enum.map(fn x -> List.to_tuple(x) end)
    # Remove empty tuples.
    |> Enum.filter(fn x -> x != {} end)
  end
end
