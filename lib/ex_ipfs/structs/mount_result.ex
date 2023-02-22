defmodule ExIpfs.MountResult do
  @moduledoc false

  defstruct [:ipfs, :fuse_allow_other, :ipns]

  @spec new(map) :: ExIpfs.mount_result()
  def new(data) when is_map(data) do
    %__MODULE__{
      fuse_allow_other: data["FuseAllowOther"],
      ipfs: data["IPFS"],
      ipns: data["IPNS"]
    }
  end
end
