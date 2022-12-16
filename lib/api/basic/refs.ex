defmodule MyspaceIPFS.Api.Basic.Refs do
  @moduledoc """
  MyspaceIPFS.Api is where the main commands of the IPFS API reside.
  """

  import MyspaceIPFS.Utils
  @refs_allowed_formats ["<dst>", "<src>", "<linkname>"]

  @doc """
  Get a list of all local references.
  """
  @spec local :: {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def local, do: request_get("/refs/local")

 defguardp is_allowed_refs_format(format)
            when format in @refs_allowed_formats

  @doc """
  Get a list of all references from a given object.

  ## Parameters
  - `multihash`: The hash of the object to list references from.
  - `format`: The format in which the output should be returned.
    Allowed values are `<dst>`, `<src>` and `<linkname>`a.
  - `edges`: If true, the output will contain edge objects.
  - `unique`: If true, the output will contain unique objects.
  - `recursive`: If true, the output will contain recursive objects.
  - `max_depth`: The maximum depth of the output.
  """
  @spec refs(binary, binary, any, any, any, integer) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def refs(
        multihash,
        format \\ "<dst>",
        edges \\ true,
        unique \\ true,
        recursive \\ true,
        max_depth \\ 1
      )
      when is_bitstring(multihash) and
             is_bitstring(format) and
             #is_allowed_refs_format(format) and
             is_boolean(edges) and
             is_boolean(unique) and
             is_boolean(recursive) and
             is_integer(max_depth) do
    path = "/refs?arg=#{multihash}&format=#{format}&edges=#{to_string(edges)}&unique=#{to_string(unique)}&recursive=#{to_string(recursive)}&max-depth=#{to_string(max_depth)}"
    request_get(path)
  end
end
