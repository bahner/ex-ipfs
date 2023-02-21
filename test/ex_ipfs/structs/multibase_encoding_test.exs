defmodule ExIpfs.MultibaseEncodingTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIpfs.MultibaseEncoding

  @data %{"Name" => "name", "Code" => 0}

  test "fails on missing data" do
    catch_error(%MultibaseEncoding{} = MultibaseEncoding.new())
  end

  test "test creation of error" do
    assert %MultibaseEncoding{} = MultibaseEncoding.new(@data)
    e = MultibaseEncoding.new(@data)
    assert e.name == "name"
    assert e.code == 0
  end

  test "passed on error data" do
    assert {:error, @data} = MultibaseEncoding.new({:error, @data})
  end
end
