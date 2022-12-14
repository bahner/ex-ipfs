defmodule MyspaceIPFS.Api.Dht do
  @moduledoc """
  MyspaceIPFS.Api.Dht is where the dht commands of the IPFS API reside.
  """
  import MyspaceIPFS.Utils

  # DHT COMMANDS
  # NB: findpeer is deprecated.
  # NB: findprovs is deprecated.
  # NB: get is deprecated.
  # NB: provide is deprecated.
  # NB: put is deprecated.

  @spec query(binary) :: any
  def query(peer_id), do: request_get("/dht/query?arg=", peer_id)
end
