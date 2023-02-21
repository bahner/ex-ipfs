defmodule ExIpfs.ApiError do
  @moduledoc false

  import ExIpfs.Utils
  require Logger

  defstruct code: nil, message: nil, type: nil

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: ExIpfs.Api.error()
  def new(map) do
    %ExIpfs.ApiError{
      code: map["Code"],
      message: map["Message"],
      type: map["Type"]
    }
  end

  @spec handle_api_error(map) :: {:error, ExIpfs.Api.error()}
  def handle_api_error(body) do
    Logger.debug("IPFS error: #{inspect(body)}")

    body
    |> new()
    |> errify()
  end
end
