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

  def gen_cid_cid({:error, data}) do
    {:error, data}
  end

  def gen_cid_cid(opts) when is_map(opts) do
    %MyspaceIpfs.CidCid{} |> struct!(opts)
  end
end
