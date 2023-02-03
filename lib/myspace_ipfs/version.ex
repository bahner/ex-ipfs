defmodule MyspaceIpfs.Version do
  @moduledoc """
  MyspaceIpfs.Version is a collection of functions for the MyspaceIpfs library.
  """
  import MyspaceIpfs.Api
  import MyspaceIpfs.Utils

  @doc """
  Get the version of the IPFS daemon.

  ## Parameters
  What version information to return (optional). Defaults to all.
  Allowed values are: all, Commit, Golang, Version, Repo, System.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-version
  """
  @spec version() :: {:ok, MyspaceIpfs.VersionVersion.t()}
  def version() do
    post_query("/version")
    |> MyspaceIpfs.VersionVersion.new()
    |> okify()
  end

  @doc """
  Get the depdency versions of the IPFS daemon.
  """
  @spec deps() :: {:ok, [MyspaceIpfs.VersionDeps.t()]}
  def deps() do
    post_query("/version/deps")
    |> Enum.map(&MyspaceIpfs.VersionDeps.new/1)
    |> okify()
  end
end
