defmodule MyspaceIPFS.CidBase32CID do
  @moduledoc """
  MyspaceIPFS.CidBase32CID is a struct returned from the IPFS Cid API.
  """

  defstruct cid_str: nil, formatted: nil, error_msg: nil

  @type t :: %__MODULE__{
          cid_str: binary,
          formatted: binary,
          error_msg: binary
        }

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      cid_str: opts["CidStr"],
      formatted: opts["Formatted"],
      error_msg: opts["ErrorMsg"]
    }
  end
end
