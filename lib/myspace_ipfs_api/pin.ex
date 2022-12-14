defmodule MyspaceIPFS.Api.Pin do
  @moduledoc """
  MyspaceIPFS.Api.Pin is where the pin commands of the IPFS API reside.
  """
  import MyspaceIPFS.Utils

  @spec add(binary) :: any
  def add(object), do: request_get("/pin/add?arg=", object)

  @spec ls(any) :: any
  def ls(object \\ "") do
    if object != "" do
      request_get("/pin/ls?arg=", object)
    else
      request_get("/pin/ls")
    end
  end

  @spec rm(binary) :: any
  def rm(object), do: request_get("/pin/rm?arg=", object)
end
