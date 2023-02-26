defmodule ExIpfs.ObjectTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIpfs.Object

  @data %{"Hash" => "hash", "Links" => [%{"Hash" => "hash", "Links" => []}]}

  test "fails on missing data" do
    catch_error(%Object{} = Object.new())
  end

  test "test creation of hash" do
    assert %Object{} = Object.new(@data)
    e = Object.new(@data)
    assert e.hash == "hash"
    assert e.links == [%Object{hash: "hash", links: []}]
  end

  test "passed error tuple passes on data" do
    assert {:error, %{"Hash" => "hash"}} = Object.new({:error, %{"Hash" => "hash"}})
  end
end
