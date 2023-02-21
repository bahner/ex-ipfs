defmodule ExIpfs.KeyValueTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIpfs.KeyValue, as: KeyValue

  @data %{"Key" => "key", "Value" => "value"}

  test "fails on missing data" do
    catch_error(%KeyValue{} = KeyValue.new())
  end

  test "test creation of error" do
    assert %KeyValue{} = KeyValue.new(@data)
    e = KeyValue.new(@data)
    assert e.key == "key"
    assert e.value == "value"
  end

  test "passes on error data" do
    {:error, result} = KeyValue.new({:error, @data})
    assert result == @data
  end
end
