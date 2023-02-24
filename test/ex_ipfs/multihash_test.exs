defmodule ExIpfs.MultihashTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias ExIpfs.Multihash

  @data %{"Name" => "name", "Code" => 0}

  test "fails on missing data" do
    catch_error(%Multihash{} = Multihash.new())
  end

  test "test creation of error" do
    assert %Multihash{} = Multihash.new(@data)
    e = Multihash.new(@data)
    assert e.name == "name"
    assert e.code == 0
  end

  test "passed on error data" do
    assert {:error, @data} = Multihash.new({:error, @data})
  end
end
