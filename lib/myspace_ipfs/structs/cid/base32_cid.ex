defmodule MyspaceIpfs.CidCid do
  @moduledoc """
  A struct that represents a CID as return from conversion function in IPFS.
  These structs are specific to the underlying IPFS API category.
  """

  defstruct cid_str: nil, formatted: nil, error_msg: nil

  @type t :: %__MODULE__{
          cid_str: binary,
          formatted: binary,
          error_msg: binary
        }

  @doc """
  Generate a new CidCid struct or passthrough an error message
  from the IPFS API
  """
  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: MyspaceIpfs.CidCid.t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      cid_str: opts.cid_str,
      formatted: opts.formatted,
      error_msg: opts.error_msg
    }
  end
end
