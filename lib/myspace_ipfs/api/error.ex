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

  defp gen_api_error(map) do
    %MyspaceIpfs.ApiError{
      code: map.code,
      message: map.message,
      type: map.type
    }
  end

  @doc false
  def handle_api_error(response) do
    Logger.debug("IPFS error: #{inspect(response)}")

    response.body
    |> snake_atomize()
    |> gen_api_error()
    |> errify()
  end
end
