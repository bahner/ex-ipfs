defmodule MyspaceIPFS.Version do
  @moduledoc """
  MyspaceIPFS.Version is a collection of functions for the MyspaceIPFS library.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils
  alias MyspaceIPFS.VersionDeps

  defstruct [:commit, :golang, :version, :repo, :system]

  @typedoc """
  MyspaceIPFS.Version.version is a struct to show the version of the IPFS daemon.
  """
  @type t :: %__MODULE__{
          commit: binary(),
          golang: binary(),
          version: binary(),
          repo: binary(),
          system: binary()
        }

  @typedoc """
  MyspaceIPFS.Version.deps is a struct to show deps of the IPFS daemon.
  """
  @type deps :: %MyspaceIPFS.VersionDeps{
          path: binary(),
          replaced_by: binary(),
          sum: binary(),
          version: binary()
        }

  @doc """
  Get the version of the IPFS daemon.

  ## Parameters
  What version information to return (optional). Defaults to all.
  Allowed values are: all, Commit, Golang, Version, Repo, System.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-version
  """
  @spec version() :: {:ok, t()}
  def version() do
    post_query("/version")
    |> new()
    |> okify()
  end

  @doc """
  Get the depdency versions of the IPFS daemon.
  """
  @spec deps() :: {:ok, [VersionDeps.t()]}
  def deps() do
    post_query("/version/deps")
    |> Enum.map(&VersionDeps.new/1)
    |> okify()
  end

  @spec new({:error, any}) :: {:error, any}
  defp new({:error, data}), do: {:error, data}

  @spec new(nil | maybe_improper_list | map) :: t()
  defp new(data) do
    %__MODULE__{
      commit: data["Commit"],
      golang: data["Golang"],
      version: data["Version"],
      repo: data["Repo"],
      system: data["System"]
    }
  end
end
