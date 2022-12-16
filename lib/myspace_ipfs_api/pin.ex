defmodule MyspaceIPFS.Api.Pin do
    @moduledoc """
  MyspaceIPFS.Api.Pin is where the pin commands of the IPFS API reside.
  """

    def pin_add(object), do: request_get("/pin/add?arg=", object)

    def pin_ls(object \\ "") do
        if object != "" do
            request_get("/pin/ls?arg=", object)
        else
            request_get("/pin/ls")
        end
    end

    def pin_rm(object), do: request_get("/pin/rm?arg=", object)
end
