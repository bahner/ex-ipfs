defmodule IpfsConnection do
    #add struct for later use. 
    defstruct host: "localhost", port: 5001, base: "api/v0", protocol: "http" 
    use Tesla
    
    #boundary for add_cmd function TODO: implement add_cmd funciton. 
    @boundary "7MA4YWxkTrZu0gW"

    plug Tesla.Middleware.BaseUrl, "http://localhost:5001/api/v0"
    plug Tesla.Middleware.JSON

    ## TODO: add (add_cmd, block, bootstrap, config, dag, dht, diag, dns, 
    ## files, id, key, log, mount, name, object, pin, ping, p2p, pubsub, 
    ## bitswap, filestore, shutdown, refs, repo, resolve, stats, tar, file)
    
    ## TODO: add get_cmd for output, archive, compress and compression level
    def get_cmd(multihash) do
        requests("/get?arg=", multihash)
        ##TODO add optional file writing funcitonality. 
    end

    def cat_cmd(multihash) do
        requests("/cat?arg=", multihash)
    end

    def swarm_peers do
        requests("/swarm/peers", "")
    end

    def swarm_disconnect(multihash) do
        res = request("/swarm/disconnect?arg=", multihash)
        res.body
    end

    #Ls cmd TODO  Implement proper Json Format. 
    def ls_cmd(multihash) do
        requests("/ls?arg=", multihash)
    end
    
    ##Currently throws an error due to the size of JSON response. 
    def repo_verify do
        requests("/repo/verify", "")
    end

    #Update function - TODO (correctly format res.body string)
    def update(args) do
        res = requests("/update?arg=", args)
        String.replace(res.body, "\n", " ")
    end

    def tour_list do
        requests("/tour/list", "")
    end

    def tour_next do
        requests("/tour/next", "")
    end

    def tour_restart do
        requests("/tour/restart", "")
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

    # TODO: implment requests/1

    defp requests(path, multihash) do
        case get(path <> multihash) do
            ## TODO: add more cases. 
            %Tesla.Env{status: 200, headers: headers, body: body} -> %{:headers => headers, :body => body}
            %Tesla.Env{status: 500, headers: headers, body: body} -> %{:headers => headers, :body => body}
            %Tesla.Env{status: 404, headers: headers} -> %{:headers=> headers, :error => "Error: 404 page not found."}
        end 
    end

    defp write_file(raw, multihash) do
      File.write(multihash, raw, [:write, :utf8])
    end
    
end