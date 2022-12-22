defmodule MyspaceIPFS.Dht do
  @moduledoc """
  MyspaceIPFS.Api.Dht is where the dht commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api

  # DHT COMMANDS
  # NB: findpeer is deprecated.
  # NB: findprovs is deprecated.
  # NB: get is deprecated.
  # NB: provide is deprecated.
  # NB: put is deprecated.

  def query(peer_id), do: post_query("/dht/query?arg=" <> peer_id)
end
