defmodule ExIpfs.ApiStreamingClientTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias ExIpfs.ApiStreamingClient, as: StreamingClient

  test "create new streaming client" do
    assert {:ok, _} = StreamingClient.new(self(), "http://localhost:5001/api/v0/add", 5000, [])
  end

  test "create new streaming client returns reference" do
    assert {:ok, ref} = StreamingClient.new(self(), "http://localhost:5001/api/v0/add", 5000, [])
    assert is_reference(ref)
  end
end
