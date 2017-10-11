defmodule IpfsConnection do
    use Tesla
    #add struct for later use. 
    defstruct host: "localhost", port: 5001, base: "api/v0", protocol: "http" 
    
    #Connection manager.
    
    plug Tesla.Middleware.BaseUrl, "http://localhost:5001/api/v0"
    plug Tesla.Middleware.JSON

    def set_headers(head) do
        Tesla.build_client([
            Tesla.Middleware.Headers, %{"Content-Type" => head}
        ])
    end

end