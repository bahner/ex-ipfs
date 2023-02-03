defmodule MyspaceIPFS.Version do
  @moduledoc """
  MyspaceIPFS.Version is a collection of functions for the MyspaceIPFS library.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @doc """
  Get the version of the IPFS daemon.

  ## Parameters
  What version information to return (optional). Defaults to all.
  Allowed values are: all, Commit, Golang, Version, Repo, System.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-version
  """
  @spec version() :: {:ok, MyspaceIPFS.VersionVersion.t()}
  def version() do
    post_query("/version")
    |> MyspaceIPFS.VersionVersion.new()
    |> okify()
  end

  @doc """
  Get the depdency versions of the IPFS daemon.
  """
  @spec deps() :: {:ok, [MyspaceIPFS.VersionDeps.t()]}
  def deps() do
    post_query("/version/deps")
    |> Enum.map(&MyspaceIPFS.VersionDeps.new/1)
    |> okify()
  end
end
