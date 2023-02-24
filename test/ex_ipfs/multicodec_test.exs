defmodule ExIpfs.MulticodecTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIpfs.Multicodec

  @data %{"Name" => "name", "Code" => 0}

  test "fails on missing data" do
    catch_error(%Multicodec{} = Multicodec.new())
  end

  test "test creation of error" do
    assert %Multicodec{} = Multicodec.new(@data)
    e = Multicodec.new(@data)
    assert e.name == "name"
    assert e.code == 0
  end

  test "passed on error data" do
    assert {:error, @data} = Multicodec.new({:error, @data})
  end
end
