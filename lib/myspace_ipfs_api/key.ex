defmodule MyspaceIPFS.Api.Key do
    @moduledoc """
  MyspaceIPFS.Api is where the key commands of the IPFS API reside.
  """
    def key_gen(key), do: request_get("/key/gen?arg=", key)

    def key_list, do: request_get("/key/list")
end
