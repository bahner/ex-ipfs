defmodule ExIpfs.ApiErrorTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIpfs.ApiError

  test "fails on missing data" do
    catch_error(%ApiError{} = ApiError.new())
  end

  test "test creation of error" do
    assert %ApiError{} = ApiError.new(%{"Message" => "message", "Code" => 0})
    e = ApiError.new(%{"Message" => "message", "Code" => 0})
    assert e.message == "message"
    assert e.code == 0
  end

  test "test creation of error with missing data" do
    assert %ApiError{} = ApiError.new(%{"Message" => "message"})
    e = ApiError.new(%{"Message" => "message"})
    assert e.message == "message"
    assert e.code == nil
  end

  test "handling of api error" do
    assert {:error, %ApiError{}} =
             ApiError.handle_api_error(%{"Message" => "message", "Code" => 0})

    e = ApiError.handle_api_error(%{"Message" => "message", "Code" => 0})
    assert e == {:error, %ApiError{message: "message", code: 0}}
  end

  test "handling of api error with missing data" do
    assert {:error, %ApiError{}} = ApiError.handle_api_error(%{"Message" => "message"})
    e = ApiError.handle_api_error(%{"Message" => "message"})
    assert e == {:error, %ApiError{message: "message", code: nil}}
  end

  test "passes on error data" do
    data = {:error, %{"Message" => "message", "Code" => 0}}
    assert {:error, _} = ApiError.new({:error, data})
  end
end
