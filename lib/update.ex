defmodule MyspaceIPFS.Update do
  # FIXME: This is a stub.  It needs to be implemented.
  @moduledoc false
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @typep result :: MyspaceIPFS.result()
  @typep cid :: MyspaceIPFS.cid()

  # Update function  - takes in the current args for update.
  # This runs ipfs update with the given arguments.
  # You probably don't want to use this unless you know what you're doing.
  @spec update(cid) :: result
  def update(args) when is_bitstring(args) do
    post_query("/update?arg=" <> args)
    |> okify()
  end
end
