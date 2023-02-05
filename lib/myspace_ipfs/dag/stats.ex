defmodule MyspaceIPFS.DagImportStats do
  @moduledoc false

  require Logger

  defstruct block_bytes_count: 0, block_count: 0

  @spec new(map) :: MyspaceIPFS.Dag.import_stats()
  def new(stats) do
    Logger.debug("DagImportStats.new(): #{inspect(stats)}")

    %__MODULE__{
      block_bytes_count: stats["BlockBytesCount"],
      block_count: stats["BlockCount"]
    }
  end
end
