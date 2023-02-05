defmodule MyspaceIPFS.ApiError do
  @moduledoc false

  import MyspaceIPFS.Utils
  require Logger

  defstruct code: nil, message: nil, type: nil

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: MyspaceIPFS.Api.error()
  def new(map) do
    %MyspaceIPFS.ApiError{
      code: map["Code"],
      message: map["Message"],
      type: map["Type"]
    }
  end

  @spec handle_api_error(map) :: {:error, MyspaceIPFS.Api.error()}
  def handle_api_error(body) do
    Logger.debug("IPFS error: #{inspect(body)}")

    body
    |> new()
    |> errify()
  end
end
