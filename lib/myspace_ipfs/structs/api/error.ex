defmodule MyspaceIpfs.ApiError do
  @moduledoc """
  IPFS error struct when API sends back a 500 status code.
  """
  import MyspaceIpfs.Utils
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

  @spec new(map) :: MyspaceIpfs.ApiError.t()
  def new(map) do
    %MyspaceIpfs.ApiError{
      code: map.code,
      message: map.message,
      type: map.type
    }
  end

  @doc """
  Convert an IPFS error message into a tuple of {:error, struct}
  """
  @spec handle_api_error(map) :: {:error, MyspaceIpfs.ApiError.t()}
  def handle_api_error(response) do
    Logger.debug("IPFS error: #{inspect(response)}")

    response.body
    |> snake_atomize()
    |> new()
    |> errify()
  end
end
