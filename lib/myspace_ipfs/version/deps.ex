defmodule MyspaceIPFS.VersionDeps do
  @moduledoc false

  defstruct path: nil, replaced_by: nil, sum: nil, version: nil

  @spec new(map) :: MyspaceIPFS.version_deps()
  def new(data) do
    %__MODULE__{
      path: data["Path"],
      replaced_by: data["ReplacedBy"],
      sum: data["Sum"],
      version: data["Version"]
    }
  end
end
