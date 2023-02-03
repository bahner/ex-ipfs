defmodule MyspaceIpfs.DagImport do
  @moduledoc """
  Object returned from importing a dag into IPFS.
  """

  import MyspaceIpfs.Utils
  require Logger

  defstruct root: nil, stats: %{}

  @type t :: %__MODULE__{
          root: MyspaceIpfs.Structs.DagImportRoot,
          stats: MyspaceIpfs.Structs.DagImportStats
        }

  @doc """
  Generate a new DagImport struct or passthrough an error message
  from the IPFS API
  """
  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(list) :: t
  def new(list) do
    list = Enum.map(list, &snake_atomize/1)
    [root | [stats]] = list

    %__MODULE__{
      root: MyspaceIpfs.DagImportRoot.new(root.root),
      stats: MyspaceIpfs.DagImportStats.new(stats.stats)
    }
  end
end

defmodule MyspaceIpfs.DagImportRoot do
  @moduledoc false

  require Logger
  defstruct cid: nil, pin_error_msg: nil

  @type t :: %__MODULE__{
          cid: MyspaceIpfs.RootCid.t(),
          pin_error_msg: binary
        }

  @doc """
  Generate a new DagImportRoot struct or passthrough an error message
  from the IPFS API
  """
  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: t
  def new(root) do
    %__MODULE__{
      cid: MyspaceIpfs.RootCid.new(root.cid),
      pin_error_msg: root.pin_error_msg
    }
  end
end

defmodule MyspaceIpfs.DagImportStats do
  @moduledoc false

  require Logger

  defstruct block_bytes_count: 0, block_count: 0

  @type t :: %__MODULE__{
          block_bytes_count: integer | nil,
          block_count: integer | nil
        }

  @doc """
  Generate a new DagImportStats struct or passthrough an error message
  from the IPFS API
  """
  # @spec new({:error, map}) :: {:error, map}
  # def new({:error, data}) do
  #   {:error, data}
  # end
  @spec new(map) :: t
  def new(stats) do
    Logger.debug("DagImportStats.new(): #{inspect(stats)}")

    %__MODULE__{
      block_bytes_count: stats.block_bytes_count,
      block_count: stats.block_count
    }
  end
end
