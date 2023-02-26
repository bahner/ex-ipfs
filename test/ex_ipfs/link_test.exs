defmodule ExIpfs.LinkTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIpfs.Link

  @data_binary %{
    "/" => "Qmname"
  }

  @data_atom %{
    /: "Qmname"
  }

  test "fails on missing data" do
    catch_error(%Link{} = Link.new())
  end

  test "test creation binary of link" do
    assert %Link{} = Link.new(@data_binary)
    e = Link.new(@data_binary)
    assert e./ == "Qmname"
  end

  test "test creation arom of link" do
    assert %Link{} = Link.new(@data_atom)
    e = Link.new(@data_atom)
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
