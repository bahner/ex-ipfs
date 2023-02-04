defmodule MyspaceIPFS.DagImport do
  @moduledoc """
  Object returned from importing a dag into IPFS.
  """

  require Logger

  defstruct root: nil, stats: %{}

  @type t :: %__MODULE__{
          root: MyspaceIPFS.Structs.DagImportRoot,
          stats: MyspaceIPFS.Structs.DagImportStats
        }

  @doc """
  Generate a new DagImport struct or passthrough an error message
  from the IPFS API
  """
  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(list) :: t()
  def new(list) do
    [root | [stats]] = list

    %__MODULE__{
      root: MyspaceIPFS.DagImportRoot.new(root["Root"]),
      stats: MyspaceIPFS.DagImportStats.new(stats["Stats"])
    }
  end
end

defmodule MyspaceIPFS.DagImportRoot do
  @moduledoc false

  require Logger
  defstruct cid: nil, pin_error_msg: nil

  @type t :: %__MODULE__{
          cid: MyspaceIPFS.SlashCID.t(),
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
      cid: MyspaceIPFS.SlashCID.new(root["Cid"]),
      pin_error_msg: root["PinErrorMsg"]
    }
  end
end

defmodule MyspaceIPFS.DagImportStats do
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
      block_bytes_count: stats["BlockBytesCount"],
      block_count: stats["BlockCount"]
    }
  end
end
