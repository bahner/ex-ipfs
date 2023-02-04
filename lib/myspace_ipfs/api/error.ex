defmodule MyspaceIPFS.ApiError do
  @moduledoc """
  IPFS error struct when API sends back a 500 status code.
  """
  import MyspaceIPFS.Utils
  require Logger

  defstruct code: nil, message: nil, type: nil

  @type t :: %__MODULE__{
          code: integer,
          message: binary,
          type: binary
        }

  @doc """
  Generate an IPFS error struct from a map or passthrough an error message
  """
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

  @doc """
  Convert an IPFS error message into a tuple of {:error, struct}
  """
  @spec handle_api_error(map) :: {:error, MyspaceIPFS.ApiError.t()}
  def handle_api_error(body) do
    Logger.debug("IPFS error: #{inspect(body)}")

    body
    |> new()
    |> errify()
  end
end