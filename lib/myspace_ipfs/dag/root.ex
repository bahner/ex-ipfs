defmodule MyspaceIPFS.DagImportRoot do
  @moduledoc false

  require Logger
  defstruct cid: nil, pin_error_msg: nil

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: MyspaceIPFS.Dag.import_root()
  def new(root) do
    %__MODULE__{
      cid: MyspaceIPFS.SlashCID.new(root["Cid"]),
      pin_error_msg: root["PinErrorMsg"]
    }
  end
end
