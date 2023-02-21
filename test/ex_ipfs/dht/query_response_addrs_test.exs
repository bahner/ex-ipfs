defmodule ExIpfs.DhtQueryResponseAddrsTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias ExIPFS.DhtQueryResponseAddrs, as: DhtQueryResponseAddrs

  @data %{
    "Addrs" => ["/ip4/foo/bar/qux"],
    "ID" => "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N"
  }

  test "fails on missing data" do
    catch_error(%DhtQueryResponseAddrs{} = DhtQueryResponseAddrs.new())
  end

  test "create new DhtQueryResponseAddrs" do
    assert %DhtQueryResponseAddrs{} = DhtQueryResponseAddrs.new(@data)
    qra = DhtQueryResponseAddrs.new(@data)
    assert is_list(qra.addrs)
    addr = List.first(qra.addrs)
    assert addr == "/ip4/foo/bar/qux"
    assert qra.id == "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N"
  end

  test "handles error data" do
    data = %{
      "Message" => "this is an error",
      "Code" => 0
    }

    assert {:error, data} = DhtQueryResponseAddrs.new({:error, data})
    assert data == %{"Code" => 0, "Message" => "this is an error"}
  end

  test "handles list of data" do
    assert is_list(DhtQueryResponseAddrs.new([@data]))
    qra = List.first(DhtQueryResponseAddrs.new([@data]))
    assert is_list(qra.addrs)
    addr = List.first(qra.addrs)
    assert addr == "/ip4/foo/bar/qux"
    assert qra.id == "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N"
  end
end
