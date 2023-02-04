defmodule MyspaceIPFS.MultibaseEncoding do
  @moduledoc """
  MyspaceIPFS.MultibaseCodec is a struct representing a multibase codec.
  """
  @enforce_keys [:name, :code]
  defstruct [:name, :code]

  @type t :: %__MODULE__{
          name: binary,
          code: non_neg_integer()
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
      code: opts["Code"]
    }
  end
end
