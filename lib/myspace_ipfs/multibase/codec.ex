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

  def new(opts) do
    %__MODULE__{
      name: opts.name,
      code: opts.code,
      prefix: Map.get(opts, :prefix, nil),
      description: Map.get(opts, :description, nil)
    }
  end
end
