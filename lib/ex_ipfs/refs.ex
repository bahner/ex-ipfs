defmodule ExIpfs.Refs do
  @moduledoc """
  ExIpfs.Refs is where the commands to lookup references are defined.

  To get a gist of the contents, try:
  ```elixir
  iex> ExIpfs.Refs.local()
  ```
  """

  import ExIpfs.Api
  import ExIpfs.Utils

  alias ExIpfs.RefsRef, as: Ref

  @typedoc """
  A ref as reported from the refs group of commands
  """
  @type t :: %ExIpfs.RefsRef{
          ref: binary(),
          err: binary() | nil
        }

  @doc """
  Get a list of all local references.

  Response is a list of ExIpfs.ref().
  """
  @spec local :: {:ok, t()} | ExIpfs.Api.error_response()
  def local,
    do:
      post_query("/refs/local")
      |> Enum.map(&Ref.new/1)
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
