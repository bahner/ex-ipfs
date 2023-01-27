defmodule MyspaceIpfs.DagImport do
  @moduledoc """
  Object returned from importing a dag into IPFS.
  """

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

  @spec new(map) :: t
  def new(opts) do
    %__MODULE__{
      root: MyspaceIpfs.DagImportRoot.new(opts.root),
      stats: MyspaceIpfs.DagImportStats.new(opts.stats)
    }
  end
end

defmodule MyspaceIpfs.DagImportRoot do
  @moduledoc false
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
  def new(opts) do
    %__MODULE__{
      cid: MyspaceIpfs.RootCid.new(opts.cid),
      pin_error_msg: opts.pin_error_msg
    }
  end
end

defmodule MyspaceIpfs.DagImportStats do
  @moduledoc false

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
  def new(opts) do
    %__MODULE__{
      block_bytes_count: opts.block_bytes_count,
      block_count: opts.block_count
    }
  end
end
