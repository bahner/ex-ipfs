defmodule ExIPFS.IdTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIPFS.Id

  @data %{
    "Addresses" => ["/ip4/"],
    "AgentVersion" => "go-ipfs/0.4.22/",
    "ID" => "Qm",
    "ProtocolVersion" => "ipfs/0.1.0",
    "PublicKey" => "CAASpgIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQD",
    "Protocols" => []
  }

  test "fails on missing data" do
    catch_error(%Id{} = Id.new())
  end

  test "passes on error dara" do
    assert {:error, @data} = Id.new({:error, @data})
  end

  test "returns hash inks struct" do
    assert %Id{} = Id.new(@data)
    e = Id.new(@data)
    assert e.addresses == ["/ip4/"]
    assert e.agent_version == "go-ipfs/0.4.22/"
    assert e.id == "Qm"
    assert e.protocol_version == "ipfs/0.1.0"
    assert e.public_key == "CAASpgIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQD"
    assert e.protocols == []
  end
end
