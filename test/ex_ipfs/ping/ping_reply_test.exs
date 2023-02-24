defmodule ExIpfs.PingReplyTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIpfs.PingReply

  test "new/1 returns a valid struct" do
    reply = %{
      "Success" => true,
      "Time" => 1,
      "Text" => "Pong received: time=1.000000 ms"
    }

    assert %PingReply{
             success: true,
             time: 1,
             text: "Pong received: time=1.000000 ms"
           } = PingReply.new(reply)
  end

  test "new/q passes on error data" do
    reply = {:error, "adapter timeout"}

    assert {:error, "adapter timeout"} = PingReply.new(reply)
  end

  test "new/1 croaks on non-structured data that isnt an error" do
    reply = "some other data"

    assert {:error, "Invalid response"} = PingReply.new(reply)
  end
end
