defmodule MyspaceIPFS.MultiHash do
  @moduledoc """
  MyspaceIPFS.MultibaseCodec is a struct representing a hash. Seems much like a codec structure to me, but hey - a rose by any other name is still a rose.
  """
  @enforce_keys [:name, :code]
  defstruct [:name, :code]

  @typedoc """
  A multihash.
  ```
  %MyspaceIPFS.MultiHash{
    name: binary(),
    code: non_neg_integer()
  }
  ```
  """
  @type t :: %__MODULE__{
          name: String.t(),
          code: non_neg_integer()
        }

  @doc false
  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}), do: {:error, data}

  @spec new(map) :: t()
  def new(opts) when is_map(opts) do
    # code and name are required and must be present.
    %MyspaceIPFS.MultiHash{
      name: opts["Name"],
      code: opts["Code"]
    }
  end
end
