defmodule MyspaceIPFS.ApiError do
  @moduledoc false

  import MyspaceIPFS.Utils
  require Logger

  defstruct code: nil, message: nil, type: nil

  # @typedoc """
  # A struct that represents an error returned by the IPFS API.
  # """
  @type t :: %__MODULE__{
          code: integer,
          message: binary,
          type: binary
        }

  @doc false
  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: MyspaceIPFS.ApiError.t()
  def new(map) do
    %MyspaceIPFS.ApiError{
      code: map["Code"],
      message: map["Message"],
      type: map["Type"]
    }
  end

  @doc false
  @spec handle_api_error(map) :: {:error, MyspaceIPFS.ApiError.t()}
  def handle_api_error(body) do
    Logger.debug("IPFS error: #{inspect(body)}")

    body
    |> new()
    |> errify()
  end
end
