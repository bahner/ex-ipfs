defmodule IpfsConnection do
    defstruct host: "localhost", port: 5001, base: "api/v0", protocol: "http" 
    use Tesla
    
    @boundary "7MA4YWxkTrZu0gW"

    plug Tesla.Middleware.BaseUrl, "http://localhost:5001/api/v0"
    plug Tesla.Middleware.JSON


    def get_cmd(multihash) do
        res = requests("/get?arg=", multihash)
        res |> write_file(multihash)
    end

    def cat_cmd(multihash) do
        res = requests("/cat?arg=", multihash)
        res
    end

    def swarm_peers() do
        requests("/swarm/peers", "")
    end

    def ls_cmd(multihash) do
        res = requests("/ls?arg=", multihash)
        res.body
    end

    defp build_url(conn, path) do
        "#{conn.protocol}://#{conn.host}:#{conn.port}/#{conn.base}/#{path}"
    end

    defp set_headers(head) do
        Tesla.build_client([
            Tesla.Middleware.Headers, %{"Content-Type" => head}
        ])
    end

    defp raw_bin_to_string(raw) do
        codepoints = String.codepoints(raw)
        val = Enum.reduce(codepoints, fn(w, r) ->
            cond do
                String.valid?(w) ->
                    r <> w
                true ->
                    << parsed :: 8 >> = w 
                    r <> << parsed :: utf8 >>
            end
        end)
    end

    defp requests(path, multihash) do
        case get(path <> multihash) do
            %Tesla.Env{status: 200, body: body} -> body
            %Tesla.Env{status: 500, body: body} -> body 
        end 
    end

    defp write_file(raw, multihash) do
      File.write(multihash, raw, [:write])
    end
    
end