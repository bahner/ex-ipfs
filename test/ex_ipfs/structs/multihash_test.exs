defmodule ExIpfs.MultiHashTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias ExIpfs.MultiHash

  @data %{"Name" => "name", "Code" => 0}

  test "fails on missing data" do
    catch_error(%MultiHash{} = MultiHash.new())
  end

  test "test creation of error" do
    assert %MultiHash{} = MultiHash.new(@data)
    e = MultiHash.new(@data)
    assert e.name == "name"
    assert e.code == 0
  end

  test "passed on error data" do
    assert {:error, @data} = MultiHash.new({:error, @data})
  end
end
