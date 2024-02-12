defmodule ExIpfs.MultibaseCodecTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIpfs.MultibaseCodec

  @data %{
    "Name" => "name",
    "Code" => 0,
    "Prefix" => "prefix",
    "Description" => "description"
  }

  test "fails on missing data" do
    catch_error(%MultibaseCodec{} = MultibaseCodec.new())
  end

  test "test creation of error" do
    assert %MultibaseCodec{} = MultibaseCodec.new(@data)
    e = MultibaseCodec.new(@data)
    assert e.name == "name"
    assert e.code == 0
    assert e.prefix == "prefix"
    assert e.description == "description"
  end

  test "passed on error data" do
    _data = {:error}
    assert {:error, @data} = MultibaseCodec.new({:error, @data})
  end
end
