defmodule MyspaceIPFS.Api.Update do
  # FIXME: This is a stub.  It needs to be implemented.
  @moduledoc false
  import MyspaceIPFS

  @type result :: MyspaceIPFS.result()
  @type opts :: MyspaceIPFS.opts()

  # Update function  - takes in the current args for update.
  # This runs ipfs update with the given arguments.
  # You probably don't want to use this unless you know what you're doing.
  @spec update(list) :: result
  def update(args) when is_bitstring(args) do
    post_query("/update?arg=", args)
    |> okify()
  end
end
