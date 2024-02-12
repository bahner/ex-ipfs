defmodule ExIpfs.PingRequest do
  @moduledoc false

  @enforce_keys [:request_id, :pid, :peer_id, :timeout, :query_options]
  defstruct request_id: nil, pid: nil, peer_id: nil, timeout: :infinity, query_options: []

  @spec new(ExIpfs.peer_id()) :: ExIpfs.Ping.request()
  @spec new(ExIpfs.peer_id(), pid) :: ExIpfs.Ping.request()
  @spec new(ExIpfs.peer_id(), pid, atom | integer) :: ExIpfs.Ping.request()
  @spec new(ExIpfs.peer_id(), pid, atom | integer, list) :: ExIpfs.Ping.request()
  def new(peer, pid \\ self(), timeout \\ :infinity, opts \\ []) do
    %__MODULE__{
      request_id: Nanoid.generate(),
      pid: pid,
      peer_id: peer,
      timeout: timeout,
      query_options: opts
    }
  end
end
