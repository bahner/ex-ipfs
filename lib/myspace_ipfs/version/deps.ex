defmodule MyspaceIpfs.VersionDeps do
  @moduledoc """
  MyspaceIpfs.VersionDeps is a struct to show deps of the IPFS daemon.
  """

  defstruct path: nil, replaced_by: nil, sum: nil, version: nil

  @type t :: %__MODULE__{
          path: binary,
          replaced_by: binary,
          sum: binary,
          version: binary
        }

  def new(data) do
    %__MODULE__{
      path: data["Path"],
      replaced_by: data["ReplacedBy"],
      sum: data["Sum"],
      version: data["Version"]
    }
  end
end
