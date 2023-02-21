defmodule ExIPFS.ApiError do
  @moduledoc false

  import ExIPFS.Utils
  require Logger

  defstruct code: nil, message: nil, type: nil

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: ExIPFS.Api.error()
  def new(map) do
    %ExIPFS.ApiError{
      code: map["Code"],
      message: map["Message"],
      type: map["Type"]
    }
  end

  @spec handle_api_error(map) :: {:error, ExIPFS.Api.error()}
  def handle_api_error(body) do
    Logger.debug("IPFS error: #{inspect(body)}")

    body
    |> new()
    |> errify()
  end
end
