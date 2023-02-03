defmodule MyspaceIpfs.VersionVersion do
  @moduledoc """
  MyspaceIpfs.Version is a struct to show the version of the IPFS daemon.
  """

  defstruct [:commit, :golang, :version, :repo, :system]

  @type t :: %__MODULE__{
          commit: binary,
          golang: binary,
          version: binary,
          repo: binary,
          system: binary
        }

  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}

  @spec new(nil | maybe_improper_list | map) :: t()
  def new(data) do
    %__MODULE__{
      commit: data["Commit"],
      golang: data["Golang"],
      version: data["Version"],
      repo: data["Repo"],
      system: data["System"]
    }
  end
end
