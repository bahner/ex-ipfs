defmodule ExIpfs.RefsTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias ExIpfs.RefsRef, as: Ref
  alias ExIpfs.Refs

  test "new/1" do
    test = %{
      "Ref" => "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N",
      "Err" => nil
    }

    assert %Ref{} = Ref.new(test)
    test = Ref.new(test)
    assert test.err == nil
    assert test.ref == "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N"
  end

  test "new/1 with error tuple" do
    test = {:error, "invalid ipfs ref path"}
    assert {:error, "invalid ipfs ref path"} = Ref.new(test)
  end

  test "new/1 with error map" do
    test = %{
      "Message" => "invalid ipfs ref path",
      "Code" => 0
    }

    assert %Ref{} = Ref.new(test)
    test = Ref.new(test)
    assert test.err == nil
    assert test.ref == nil
  end

  test "local/0" do
    assert {:ok, _} = Refs.local()
    {:ok, refs} = Refs.local()
    assert Enum.all?(refs, fn ref -> is_map(ref) end)
    assert %Ref{} = Enum.at(refs, 0)
  end

  # test "refs give answer for Hello world" do
  #   {:ok, refs} = Refs.refs("QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N")
  #   assert Enum.all?(refs, fn ref -> is_map(ref) end)
  #   assert %Ref{} = Enum.at(refs, 0)
  # end
end
