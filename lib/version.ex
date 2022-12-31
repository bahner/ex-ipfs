defmodule MyspaceIPFS.Version do
  @moduledoc """
  MyspaceIPFS.Api.Version is a collection of functions for the MyspaceIPFS library.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @typep result :: MyspaceIPFS.result()

  @doc """
  Get the version of the IPFS daemon.

  ## Parameters
  What version information to return (optional). Defaults to all.
  Allowed values are: all, Commit, Golang, Version, Repo, System.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-version
  """
  @spec version(binary) :: result
  def version(name \\ "all") do
    post_query("/version")
    |> handle_response_data()
    |> List.flatten()
    |> return_version(name)
    |> okify()
  end

  defp return_version(versions, key) do
    if key == "all" do
      versions
    else
      get_version(versions, key)
    end
  end

  defp get_version(versions, key) do
    with versions <- Enum.find(versions, fn {k, _v} -> k == key end) do
      try do
        versions |> elem(1)
      rescue
        _ in ArgumentError -> {:error, "Invalid key: #{key}"}
      end
    end
  end

  @doc """
  Get the depdency versions of the IPFS daemon.
  """
  @spec deps() :: result
  def deps() do
    post_query("/version/deps")
    |> handle_response_data()
    |> okify()
  end
end
