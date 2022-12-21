defmodule MyspaceIPFS.Connection do
  use Tesla
  alias Tesla.Multipart

  @moduledoc """
  IpfsConnection is the main connector for the API.
  This module is mainly in place to setup the Tesla Middleware
  and the functions that modify the web responses and requests.
  """

  # add struct for later use.

  # Connection manager.

  plug(Tesla.Middleware.BaseUrl, "http://localhost:5001/api/v0")
  plug(Tesla.Middleware.JSON)

  def setup_multipart_form(file_path) do
    Multipart.new()
    |> Multipart.add_file(file_path,
      name: "\" file \"",
      filename: "\"" <> file_path <> "\"",
      detect_content_type: true
    )
  end
end
