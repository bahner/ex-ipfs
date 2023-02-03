defmodule MyspaceIPFS.MultiHash do
  @moduledoc """
  MyspaceIPFS.MultibaseCodec is a struct representing a hash. Seems much like a codec structure to me, but hey. Things may differ.
  """
  @enforce_keys [:name, :code]
  defstruct [:name, :code]

  @type t :: %__MODULE__{
          name: String.t(),
          code: non_neg_integer()
        }

  @doc """
  Generate a new MultibaseCodec struct or passthrough an error message
  from the IPFS API
  """
  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}), do: {:error, data}
  @spec new(map) :: MyspaceIPFS.MultiHash.t()
  def new(opts) do
    # code and name are required and must be present.
    %MyspaceIPFS.MultiHash{
      name: opts.name,
      code: opts.code
    }
  end
end
