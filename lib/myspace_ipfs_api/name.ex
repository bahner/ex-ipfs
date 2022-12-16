defmodule MyspaceIPFS.Api.Name do
    @moduledoc """
  MyspaceIPFS.Api.Name is where the name commands of the IPFS API reside.
  """
    def name_publish(path), do: request_get("/name/publish?arg=", path)

    def name_resolve, do: request_get("/name/resolve")
end
