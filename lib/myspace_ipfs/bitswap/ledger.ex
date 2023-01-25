defmodule MyspaceIPFS.BitswapLedger do
  @moduledoc false
  defstruct [:exchanged, :peer, :recv, :sent, :value]

  @type t :: %__MODULE__{
          exchanged: pos_integer(),
          peer: String.t(),
          recv: pos_integer(),
          sent: pos_integer(),
          value: float()
        }
end
