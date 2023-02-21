defmodule ExIpfs.HashLinksTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIpfs.HashLinks, as: HashLinks

  @data %{
    "Hash" => "hash",
    "Links" => [
      %{
        "Hash" => "hash",
        "Name" => "name",
        "Size" => 0,
        "Target" => "target",
        "Type" => 0
      }
    ]
  }

  test "fails on missing data" do
    catch_error(%HashLinks{} = HashLinks.new())
  end

  test "test creation of hash links" do
    assert %HashLinks{} = HashLinks.new(@data)
    e = HashLinks.new(@data)
    assert e.hash == "hash"

    assert e.links == [
             %ExIpfs.Hash{hash: "hash", name: "name", size: 0, target: "target", type: 0}
           ]
  end

  test "pass on error data" do
    assert {:error, @data} = HashLinks.new({:error, @data})
  end
end
