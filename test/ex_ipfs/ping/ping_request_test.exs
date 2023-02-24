defmodule ExIpfs.PingRequestTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIpfs.PingRequest

  test "new/1 returns a valid struct" do
    request = %{
      "pid" => self(),
      "peer_id" => "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N",
      "timeout" => 5000,
      "query_options" => []
    }

    assert %PingRequest{} = PingRequest.new(request)
  end

  test "new/1 returns a valid struct with a request_id" do
    request = %{
      "pid" => self(),
      "peer_id" => "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N",
      "timeout" => 5000,
      "query_options" => []
    }

    assert %PingRequest{
             request_id: _request_id
           } = PingRequest.new(request)
  end
end
