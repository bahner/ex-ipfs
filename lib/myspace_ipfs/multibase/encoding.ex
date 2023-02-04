defmodule MyspaceIPFS.MultibaseEncoding do
  @moduledoc """
  MyspaceIPFS.MultibaseEncoding is a struct returned from the IPFS Multibase API.
  """
  @enforce_keys [:name, :code]
  defstruct [:name, :code]

  @type t :: %__MODULE__{
          name: binary,
          code: non_neg_integer()
        }

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      name: opts["Name"],
      code: opts["Code"]
    }
  end
end
