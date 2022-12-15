defmodule MyspaceIPFS.Api.Basic.Refs do
  @moduledoc """
  MyspaceIPFS.Api is where the main commands of the IPFS API reside.
  """

  import MyspaceIPFS.Utils

  @doc """
  Get a list of all local references.
  """
  @spec local :: any
  def local, do: request_get("/refs/local")

  @spec refs(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def refs(multihash) when is_bitstring(multihash), do: request_get("/refs?arg=", multihash)
end
