defmodule ExIpfs.Multicodec do
  @moduledoc false

  @enforce_keys [:name, :code]
  defstruct [:name, :code]

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}), do: {:error, data}

  @spec new(map) :: ExIpfs.multi_codec()
  def new(opts) when is_map(opts) do
    # code and name are required and must be present.
    %__MODULE__{
      name: opts["Name"],
      code: opts["Code"]
    }
  end
end
