defmodule ExIPFS.CidBase32CID do
  @moduledoc false

  defstruct cid_str: nil, formatted: nil, error_msg: nil

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: ExIPFS.Cid.base32cid()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      cid_str: opts["CidStr"],
      formatted: opts["Formatted"],
      error_msg: opts["ErrorMsg"]
    }
  end
end
