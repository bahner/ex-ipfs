defmodule MyspaceIPFS.MultibaseCodec do
  @moduledoc """
  MyspaceIPFS.MultibaseCodec is a struct representing a multibase codec.
  """
  @enforce_keys [:name, :code]
  defstruct [:name, :code, prefix: nil, description: nil]

  @type t :: %__MODULE__{
          name: String.t(),
          code: non_neg_integer(),
          prefix: String.t(),
          description: String.t()
        }

  @doc """
  Generate a new MultibaseCodec struct or passthrough an error message
  from the IPFS API
  """
  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: t()
  def new(opts) do
    %__MODULE__{
      name: opts["Name"],
      code: opts["Code"],
      prefix: Map.get(opts, "Prefix", nil),
      description: Map.get(opts, "Description", nil)
    }
  end
end
