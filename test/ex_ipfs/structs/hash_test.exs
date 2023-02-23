defmodule ExIpfs.ObjectTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIpfs.Object, as: Hash

  test "fails on missing data" do
    catch_error(%Hash{} = Hash.new())
  end

  test "test creation of hash" do
    assert %Hash{} = Hash.new(%{"Hash" => "hash"})
    e = Hash.new(%{"Hash" => "hash"})
    assert e.hash == "hash"
  end

  test "passed error tuple passes on data" do
    assert {:error, %{"Hash" => "hash"}} = Hash.new({:error, %{"Hash" => "hash"}})
  end
end
