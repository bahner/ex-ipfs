defmodule MyspaceIPFS.MultibaseCodec do
  @moduledoc """
  MyspaceIPFS.MultibaseCodec is a struct returned from the IPFS Multibase API.
  """
  @enforce_keys [:name, :code]
  defstruct [:name, :code, prefix: nil, description: nil]

  @type t :: %__MODULE__{
          name: binary(),
          code: non_neg_integer(),
          prefix: binary(),
          description: binary()
        }

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      name: opts["Name"],
      code: opts["Code"],
      prefix: Map.get(opts, "Prefix", nil),
      description: Map.get(opts, "Description", nil)
    }
  end
end
