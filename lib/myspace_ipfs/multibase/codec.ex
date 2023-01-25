defmodule MyspaceIPFS.Multibase.Codec do
  @moduledoc """
  MyspaceIPFS.Multibase.Codec is a struct representing a multibase codec.
  """
  @enforce_keys [:name, :code]
  defstruct [:name, :code, prefix: nil, description: nil]

  @type t :: %__MODULE__{
          name: String.t(),
          code: non_neg_integer(),
          prefix: String.t(),
          description: String.t()
        }

  def gen_multibase_codec(opts) do
    # code and name are required and must be present.
    %MyspaceIPFS.Multibase.Codec{
      name: opts.name,
      code: opts.code,
      prefix: Map.get(opts, :prefix, nil),
      description: Map.get(opts, :description, nil)
    }
  end
end
