defmodule IpfsElixirApiTest do
  use ExUnit.Case, async: true
  doctest IpfsConnection

  import IpfsConnection

  test "get_cmd should return a map when passed a valid key" do
    bin = get_cmd("QmP3LE29sJf8vsnTG8dMeDEcrfoW2cyUG5XVUNKWZxg38i")
    assert is_map(bin)
    assert is_binary(bin.body)
    assert is_map(bin.headers)
    assert bin[:error] == nil
  end

  test "get_cmd should return an error when passed nothing or invalid key" do 
    bin = get_cmd("test_case")
    assert is_map(bin)
    assert bin.body["Message"] === "invalid 'ipfs ref' path"
    assert bin.body["Code"] === 0
  end





  ##TODO: add Unit testing
end
