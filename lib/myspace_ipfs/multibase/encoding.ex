defmodule MyspaceIPFS.MultibaseEncoding do
  @moduledoc false
  @enforce_keys [:name, :code]
  defstruct [:name, :code]

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: MyspaceIPFS.Multibase.encoding()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      name: opts["Name"],
      code: opts["Code"]
    }
  end
end
