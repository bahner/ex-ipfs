defmodule MyspaceIPFS.DagImportRoot do
  @moduledoc false

  alias MyspaceIPFS.Link
  require Logger
  defstruct cid: nil, pin_error_msg: nil

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: MyspaceIPFS.Dag.import_root()
  def new(root) do
    %__MODULE__{
      cid: Link.new(root["Cid"]),
      pin_error_msg: root["PinErrorMsg"]
    }
  end
end
