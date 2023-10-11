defmodule ExIpfs.Id do
  @moduledoc false

  defstruct [
    :addresses,
    :agent_version,
    :id,
    :public_key,
    :protocols
  ]

  @spec new(map) :: ExIpfs.id()
  def new(map) when is_map(map) do
    %__MODULE__{
      addresses: map["Addresses"],
      agent_version: map["AgentVersion"],
      id: map["ID"],
      public_key: map["PublicKey"],
      protocols: map["Protocols"]
    }
  end

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}), do: {:error, data}
end
