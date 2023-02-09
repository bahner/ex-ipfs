defmodule MyspaceIPFS.DhtQueryResponseTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias MyspaceIPFS.DhtQueryResponse, as: DhtQueryResponse
  alias MyspaceIPFS.DhtQueryResponseAddrs, as: DhtQueryResponseAddrs

  @query_response %{
    "Extra" => "extra",
    "ID" => "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N",
    "Responses" => [
      %{
        "Addrs" => [
          "/ip4/foo/bar/qux"
        ],
        "ID" => "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N"
      }
    ],
    "Type" => "type"
  }

  test "fails on missing data" do
    catch_error(%DhtQueryResponse{} = DhtQueryResponse.new())
  end

  test "create query response" do
    assert %DhtQueryResponse{} = DhtQueryResponse.new(@query_response)
    qr = DhtQueryResponse.new(@query_response)
    assert qr.extra == "extra"
    assert qr.id == "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N"
    assert qr.type == "type"
    assert %DhtQueryResponseAddrs{} = List.first(qr.responses)
  end

  test "create query response list" do
    assert is_list(DhtQueryResponse.new([@data]))
    qr = List.first(DhtQueryResponse.new([@data]))
    qr = DhtQueryResponse.new(@query_response)
    assert qr.extra == "extra"
    assert qr.id == "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N"
    assert qr.type == "type"
  end
end
