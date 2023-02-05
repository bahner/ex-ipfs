defmodule MyspaceIPFS.DagImport do
  @moduledoc false
  require Logger

  defstruct root: nil, stats: %{}

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(list) :: MyspaceIPFS.Dag.import()
  def new(list) do
    [root | [stats]] = list

    %__MODULE__{
      root: MyspaceIPFS.DagImportRoot.new(root["Root"]),
      stats: MyspaceIPFS.DagImportStats.new(stats["Stats"])
    }
  end
end
