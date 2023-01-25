defmodule MyspaceIPFS.BitswapWantList do
  @moduledoc false

  defstruct keys: nil

  @type t :: %__MODULE__{
          keys: List.t()
        }
end
