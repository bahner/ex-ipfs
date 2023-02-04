defmodule MyspaceIPFS.Version do
  @moduledoc """
  MyspaceIPFS.Version is a collection of functions for the MyspaceIPFS library.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils
  alias MyspaceIPFS.VersionVersion
  alias MyspaceIPFS.VersionDeps

  @typep version_deps :: VersionDeps.t()

  @doc """
  Get the version of the IPFS daemon.

  ## Parameters
  What version information to return (optional). Defaults to all.
  Allowed values are: all, Commit, Golang, Version, Repo, System.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-version
  """
  @spec version() :: {:ok, VersionVersion.t()}
  def version() do
    post_query("/version")
    |> VersionVersion.new()
    |> okify()
  end

  @doc """
  Get the depdency versions of the IPFS daemon.
  """
  @spec deps() :: {:ok, [version_deps]}
  def deps() do
    post_query("/version/deps")
    |> Enum.map(&VersionDeps.new/1)
    |> okify()
  end
end
