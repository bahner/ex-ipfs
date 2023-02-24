defmodule ExIpfs.MultibaseTest do
  @moduledoc false
  use ExUnit.Case, async: true
  alias ExIpfs.Multibase

  test "encode base64url" do
    {:ok, encoded} = Multibase.encode("hello world", b: "base64url")
    assert encoded == "uaGVsbG8gd29ybGQ"
  end

  test "encode base64url without opts" do
    {:ok, encoded} = Multibase.encode("hello world")
    assert encoded == "uaGVsbG8gd29ybGQ"
  end

  test "decode base64url" do
    {:ok, decoded} = Multibase.decode("uaGVsbG8gd29ybGQ")
    assert decoded == "hello world"
  end

  test "encode list to base64url" do
    {:ok, encoded} = Multibase.encode(["hello", "world"], b: "base64url")
    assert "uaGVsbG8" == List.first(encoded)
    assert "ud29ybGQ" == List.last(encoded)
  end

  test "decode list from base64url" do
    {:ok, decoded} = Multibase.decode(["uaGVsbG8", "ud29ybGQ"])
    assert "hello" == List.first(decoded)
    assert "world" == List.last(decoded)
  end

  test "list returns list of encodings" do
    test = %ExIpfs.MultibaseCodec{
      name: "base256emoji",
      code: 128_640,
      prefix: nil,
      description: nil
    }

    {:ok, encodings} = Multibase.list()
    assert Enum.member?(encodings, test)
  end

  test "transcoding translates correctly" do
    input = "uaGVsbG8"
    output = "f68656c6c6f"

    {:ok, decoded} = Multibase.transcode(input, b: "base16")
    assert decoded == output

    {:ok, decoded} = Multibase.transcode(output, b: "base64url")
    assert decoded == input
  end
end
