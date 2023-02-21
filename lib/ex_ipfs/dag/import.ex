defmodule ExIPFS.DagImport do
  @moduledoc false
  require Logger

  defstruct root: nil, stats: %{}

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(list) :: ExIPFS.Dag.import()
  def new(list) do
    [root | [stats]] = list

    %__MODULE__{
      root: ExIPFS.DagImportRoot.new(root["Root"]),
      stats: ExIPFS.DagImportStats.new(stats["Stats"])
    }
  end
end
