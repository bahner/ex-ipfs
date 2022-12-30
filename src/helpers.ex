defmodule Helpers do
  def extract_token({_token, _line, value}) do
  IO.puts(value)
  value
  end
  def put_tuple({key, value}) do
    Map.new([{key, value}])
  end
  def put_tuple({key, value}, map) do
    Map.put(map, key, value)
  end
end
