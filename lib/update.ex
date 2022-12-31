defmodule MyspaceIPFS.Update do
  # FIXME: This is a stub.  It needs to be implemented.
  @moduledoc false
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @typep result :: MyspaceIPFS.result()

  @doc """
  Update IPFS via IPFS.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-update
  `args` - The arguments to pass to the update command.
  """
  @spec update(binary) :: result
  def update(args) do
    post_query("/update?arg=" <> args)
    |> handle_data_response()
  end
end
