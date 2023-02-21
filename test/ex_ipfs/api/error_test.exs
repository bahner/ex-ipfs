defmodule ExIPFS.ApiErrorTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIPFS.ApiError, as: ApiError

  test "fails on missing data" do
    catch_error(%ApiError{} = ApiError.new())
  end

  test "test creation of error" do
    assert %ApiError{} = ApiError.new(%{"Message" => "message", "Code" => 0})
    e = ApiError.new(%{"Message" => "message", "Code" => 0})
    assert e.message == "message"
    assert e.code == 0
  end
end
