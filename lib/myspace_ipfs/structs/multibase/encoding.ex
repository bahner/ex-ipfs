defmodule MyspaceIpfs.MultibaseEncoding do
  @moduledoc """
  MyspaceIpfs.MultibaseCodec is a struct representing a multibase codec.
  """
  @enforce_keys [:name, :code]
  defstruct [:name, :code]

  @type t :: %__MODULE__{
          name: String.t(),
          code: non_neg_integer()
        }

  def gen_multibase_encoding(opts) do
    # code and name are required and must be present.
    %MyspaceIpfs.MultibaseEncoding{
      name: opts.name,
      code: opts.code
    }
  end
end
