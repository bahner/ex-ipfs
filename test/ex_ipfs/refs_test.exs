defmodule ExIpfs.RefsTest do
  @moduledoc false
  use ExUnit.Case, async: true

  test "new/1" do
    test = %{
      "Ref" => "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N",
      "Err" => nil
    }

    assert %ExIpfs.Ref{} = ExIpfs.Ref.new(test)
    test = ExIpfs.Ref.new(test)
    assert test.err == nil
    assert test.ref == "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N"
  end

  test "new/1 with error tuple" do
    test = {:error, "invalid ipfs ref path"}
    assert {:error, "invalid ipfs ref path"} = ExIpfs.Ref.new(test)
  end

  test "new/1 with error map" do
    test = %{
      "Message" => "invalid ipfs ref path",
      "Code" => 0
    }

    assert %ExIpfs.Ref{} = ExIpfs.Ref.new(test)
    test = ExIpfs.Ref.new(test)
    assert test.err == nil
    assert test.ref == nil
  end

  test "local/0" do
    assert {:ok, _} = ExIpfs.Refs.local()
    {:ok, refs} = ExIpfs.Refs.local()
    assert Enum.all?(refs, fn ref -> is_map(ref) end)
    assert %ExIpfs.Ref{} = Enum.at(refs, 0)
  end

  # test "refs give answer for Hello world" do
  #   {:ok, refs} = ExIpfs.Refs.refs("QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N")
  #   assert Enum.all?(refs, fn ref -> is_map(ref) end)
  #   assert %ExIpfs.Ref{} = Enum.at(refs, 0)
  # end
end
