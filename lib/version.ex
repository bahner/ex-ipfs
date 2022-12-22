defmodule MyspaceIPFS.Api.Version do
  @moduledoc """
  MyspaceIPFS.Api.Version is a collection of functions for the MyspaceIPFS library.
  """
  import MyspaceIPFS.Api

  @type result :: MyspaceIPFS.result()
  @type opts :: MyspaceIPFS.opts()

  # version function - does not currently accept the optional arguments on golang client.
  @spec version(opts) :: result
  def version(opts \\ nil) do
    post_query("/version", opts)
    |> okify()
  end

  @spec deps() :: result
  def deps() do
    post_query("/version/deps")
    |> okify()
  end
end
