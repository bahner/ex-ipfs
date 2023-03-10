defmodule ExIpfs.Multihash do
  @moduledoc false
  @enforce_keys [:name, :code]
  defstruct [:name, :code]

  @doc false
  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}), do: {:error, data}

  @spec new(map) :: ExIpfs.multi_hash()
  def new(opts) when is_map(opts) do
    # code and name are required and must be present.
    %ExIpfs.Multihash{
      name: opts["Name"],
      code: opts["Code"]
    }
  end
end
