defmodule ExIpfs.ObjectLinksTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIpfs.ObjectLinks, as: ObjectLinks

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
    catch_error(%ObjectLinks{} = ObjectLinks.new())
  end

  test "test creation of hash links" do
    assert %ObjectLinks{} = ObjectLinks.new(@data)
    e = ObjectLinks.new(@data)
    assert e.hash == "hash"

    assert e.links == [
             %ExIpfs.Object{hash: "hash", name: "name", size: 0, target: "target", type: 0}
           ]
  end

  test "pass on error data" do
    assert {:error, @data} = ObjectLinks.new({:error, @data})
  end
end
