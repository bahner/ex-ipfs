defmodule ExIpfs.MultibaseCodec do
  @moduledoc false
  @enforce_keys [:name, :code]
  defstruct [:name, :code, prefix: nil, description: nil]

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: ExIpfs.Multibase.codec()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      name: opts["Name"],
      code: opts["Code"],
      prefix: Map.get(opts, "Prefix", nil),
      description: Map.get(opts, "Description", nil)
    }
  end
end
