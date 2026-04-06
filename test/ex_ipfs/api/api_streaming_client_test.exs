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
    assert_receive {:query_string, query}, 2_000
    assert query == "arg=peer123&count=3" or query == "count=3&arg=peer123"

    responses = collect_finch_responses_until_done()
    assert {:status, 200} in responses

    assert Enum.any?(responses, fn msg ->
             match?({:headers, headers} when is_list(headers), msg)
           end)

    assert Enum.any?(responses, fn msg -> is_binary(msg) and String.contains?(msg, "ok") end)
    assert :done in responses
  end

  test "new/4 merges query options when url has no query" do
    bypass = Bypass.open()
    parent = self()

    Bypass.expect_once(bypass, "POST", "/api/v0/ping", fn conn ->
      send(parent, {:query_string, conn.query_string})
      Plug.Conn.send_resp(conn, 200, "ok")
    end)

    assert {:ok, pid} =
             StreamingClient.new(
               self(),
               "http://localhost:#{bypass.port}/api/v0/ping",
               5_000,
               count: 3
             )

    assert is_pid(pid)
    assert_receive {:query_string, "count=3"}, 2_000

    responses = collect_finch_responses_until_done()
    assert {:status, 200} in responses
    assert :done in responses
  end

  test "new/4 forwards trailer chunks" do
    {port, server_task} = start_chunked_server_with_trailers()

    assert {:ok, pid} =
             StreamingClient.new(self(), "http://127.0.0.1:#{port}/api/v0/ping", 5_000, [])

    assert is_pid(pid)

    responses = collect_finch_responses_until_done()
    assert {:status, 200} in responses

    assert Enum.any?(responses, fn
             {:trailers, trailers} when is_list(trailers) ->
               Enum.any?(trailers, fn {key, value} ->
                 String.downcase(to_string(key)) == "x-stream-error" and
                   to_string(value) == "trailer boom"
               end)

             _ ->
               false
           end)

    assert :done in responses
    assert :ok == Task.await(server_task, 2_000)
  end

  test "new/4 forwards stream errors when connection fails" do
    assert {:ok, pid} = StreamingClient.new(self(), "http://127.0.0.1:1/api/v0/ping", 250, [])

    assert is_pid(pid)
    assert_receive {:finch_response, {:error, _reason}}, 2_000
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

  defp start_chunked_server_with_trailers do
    {:ok, listen_socket} =
      :gen_tcp.listen(0, [:binary, {:packet, :raw}, {:active, false}, {:reuseaddr, true}])

    {:ok, {_, port}} = :inet.sockname(listen_socket)

    task =
      Task.async(fn ->
        {:ok, socket} = :gen_tcp.accept(listen_socket, 2_000)
        {:ok, _request} = :gen_tcp.recv(socket, 0, 2_000)

        body = ~s({"Success":true,"Time":1}\n)
        chunk_size = Integer.to_string(byte_size(body), 16)

        :ok =
          :gen_tcp.send(socket, [
            "HTTP/1.1 200 OK\r\n",
            "transfer-encoding: chunked\r\n",
            "trailer: x-stream-error\r\n",
            "content-type: application/json\r\n",
            "\r\n",
            chunk_size,
            "\r\n",
            body,
            "\r\n",
            "0\r\n",
            "x-stream-error: trailer boom\r\n",
            "\r\n"
          ])

        :gen_tcp.close(socket)
        :gen_tcp.close(listen_socket)
        :ok
      end)

    {port, task}
  end
end
