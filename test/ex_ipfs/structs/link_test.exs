defmodule ExIpfs.LinkTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIpfs.Link

  @data %{
    "/" => "Qmname"
  }

  test "fails on missing data" do
    catch_error(%Link{} = Link.new())
  end

  test "test creation of link" do
    assert %Link{} = Link.new(@data)
    e = Link.new(@data)
    assert e./ == "Qmname"
  end

  test "creates link from binary" do
    assert %Link{} = Link.new("Qmname")
    e = Link.new("Qmname")
    assert e./ == "Qmname"
  end

  test "passes on error data" do
    {:error, result} = Link.new({:error, @data})
    assert result == @data
  end
end
