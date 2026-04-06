defmodule ExIpfs.PingTest do
  @moduledoc false

  use ExUnit.Case, async: true
  import ExUnit.CaptureLog

  alias ExIpfs.Ping
  alias ExIpfs.PingReply

  test "handle_info handles status updates" do
    state = %{peer_id: "QmPeer", pid: self()}

    assert {:noreply, ^state} = Ping.handle_info({:finch_response, {:status, 200}}, state)
  end

  test "handle_info handles header updates" do
    state = %{peer_id: "QmPeer", pid: self()}

    assert {:noreply, ^state} =
             Ping.handle_info(
               {:finch_response, {:headers, [{"content-type", "application/json"}]}},
               state
             )
  end

  test "handle_info decodes json ping reply and forwards it" do
    state = %{peer_id: "QmPeer", pid: self()}

    assert {:noreply, ^state} =
             Ping.handle_info(
               {:finch_response, ~s({"Success":true,"Time":7,"Text":"Pong received"})},
               state
             )

    assert_receive %PingReply{success: true, time: 7, text: "Pong received"}
  end

  test "handle_info forwards non-json payload as-is" do
    state = %{peer_id: "QmPeer", pid: self()}

    assert {:noreply, ^state} = Ping.handle_info({:finch_response, "raw-data"}, state)
    assert_receive "raw-data"
  end

  test "handle_info returns normal stop when stream is done" do
    state = %{peer_id: "QmPeer", pid: self()}

    assert {:stop, :normal, ^state} = Ping.handle_info({:finch_response, :done}, state)
  end

  test "handle_info returns error stop when stream fails" do
    state = %{peer_id: "QmPeer", pid: self()}

    capture_log(fn ->
      assert {:stop, :closed, ^state} =
               Ping.handle_info({:finch_response, {:error, :closed}}, state)
    end)
  end

  test "handle_info returns stream_error stop when trailer reports stream error" do
    state = %{peer_id: "QmPeer", pid: self()}

    capture_log(fn ->
      assert {:stop, {:stream_error, "peer not reachable"}, ^state} =
               Ping.handle_info(
                 {:finch_response, {:trailers, [{"x-stream-error", "peer not reachable"}]}},
                 state
               )
    end)
  end
end
