defmodule ExIpfs.ApiStreamingClientTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias ExIpfs.ApiStreamingClient, as: StreamingClient

  test "create new streaming client returns task pid" do
    bypass = Bypass.open()

    Bypass.expect_once(bypass, "POST", "/api/v0/add", fn conn ->
      conn = Plug.Conn.send_chunked(conn, 200)
      {:ok, conn} = Plug.Conn.chunk(conn, ~s({"Success":true,"Time":1,"Text":"pong"}\n))
      conn
    end)

    assert {:ok, pid} =
             StreamingClient.new(self(), "http://localhost:#{bypass.port}/api/v0/add", 5_000, [])

    assert is_pid(pid)

    responses = collect_finch_responses_until_done()
    assert {:status, 200} in responses

    assert Enum.any?(responses, fn msg ->
             match?({:headers, headers} when is_list(headers), msg)
           end)

    assert Enum.any?(responses, &is_binary/1)
    assert :done in responses
  end

  test "new/4 merges existing and provided query options" do
    bypass = Bypass.open()
    parent = self()

    Bypass.expect_once(bypass, "POST", "/api/v0/ping", fn conn ->
      send(parent, {:query_string, conn.query_string})
      Plug.Conn.send_resp(conn, 200, "ok")
    end)

    assert {:ok, pid} =
             StreamingClient.new(
               self(),
               "http://localhost:#{bypass.port}/api/v0/ping?arg=peer123",
               5_000,
               count: 3
             )

    assert is_pid(pid)
    assert_receive {:query_string, query}
    assert query == "arg=peer123&count=3" or query == "count=3&arg=peer123"

    responses = collect_finch_responses_until_done()
    assert {:status, 200} in responses

    assert Enum.any?(responses, fn msg ->
             match?({:headers, headers} when is_list(headers), msg)
           end)

    assert Enum.any?(responses, fn msg -> is_binary(msg) and String.contains?(msg, "ok") end)
    assert :done in responses
  end

  defp collect_finch_responses_until_done(acc \\ []) do
    receive do
      {:finch_response, :done} ->
        Enum.reverse([:done | acc])

      {:finch_response, msg} ->
        collect_finch_responses_until_done([msg | acc])
    after
      1_000 ->
        flunk("timed out waiting for :finch_response stream completion")
    end
  end
end
