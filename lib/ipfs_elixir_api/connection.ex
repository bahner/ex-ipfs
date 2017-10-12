defmodule IpfsConnection do
    use Tesla
    alias Tesla.Multipart
    #add struct for later use. 
    
    #Connection manager.
    
    plug Tesla.Middleware.BaseUrl, "http://localhost:5001/api/v0"
    plug Tesla.Middleware.JSON

    def set_headers(head) do
        Tesla.build_client([
            Tesla.Middleware.Headers, %{"Content-Type" => head}
        ])
    end

    def setup_multipart_form(file_path) do
            Multipart.new
            |> Multipart.add_file(file_path, [name: "\" file \"", filename: "\"" <> file_path <> "\"", detect_content_type: true])
    end

end


