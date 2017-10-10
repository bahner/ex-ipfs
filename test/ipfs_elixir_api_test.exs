defmodule IpfsElixirApiTest do
  use ExUnit.Case
  doctest IpfsElixirApi

  test "greets the world" do
    assert IpfsElixirApi.hello() == :world
  end
end
