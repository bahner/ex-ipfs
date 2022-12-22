defmodule MyspaceIPFS.Pin do
  @moduledoc """
  MyspaceIPFS.Api.Pin is where the pin commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api

  def add(object), do: post_query("/pin/add?arg=" <> object)

  def ls(object \\ "") do
    if object != "" do
      post_query("/pin/ls?arg=" <> object)
    else
      post_query("/pin/ls")
    end
  end

  def rm(object), do: post_query("/pin/rm?arg=" <> object)
end
