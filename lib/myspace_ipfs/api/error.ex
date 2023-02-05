defmodule MyspaceIPFS.ApiError do
  @moduledoc """
  MyspaceIPFS.ApiError is a struct returned from the IPFS API.
  """

  import MyspaceIPFS.Utils
  require Logger

  defstruct code: nil, message: nil, type: nil

  @typedoc """
  A structured error returned from the upstream IPFS API.

  ```
  %MyspaceIPFS.ApiError{
    code: 0,
    message: "some message",
    type: "error type"
  }
  ```
  """
  @type t :: %__MODULE__{
          code: integer,
          message: binary,
          type: binary
        }

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: t()
  def new(map) do
    %MyspaceIPFS.ApiError{
      code: map["Code"],
      message: map["Message"],
      type: map["Type"]
    }
  end

  @doc false
  @spec handle_api_error(map) :: {:error, t()}
  def handle_api_error(body) do
    Logger.debug("IPFS error: #{inspect(body)}")

    body
    |> new()
    |> errify()
  end
end
