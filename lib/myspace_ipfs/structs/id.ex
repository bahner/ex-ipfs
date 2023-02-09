defmodule MyspaceIPFS.Id do
  @moduledoc false

  defstruct [
    :addresses,
    :agent_version,
    :id,
    :protocol_version,
    :public_key,
    :protocols
  ]

  @spec new(map) :: MyspaceIPFS.id()
  def new(map) do
    %__MODULE__{
      addresses: map["Addresses"],
      agent_version: map["AgentVersion"],
      id: map["ID"],
      protocol_version: map["ProtocolVersion"],
      public_key: map["PublicKey"],
      protocols: map["Protocols"]
    }
  end
end
