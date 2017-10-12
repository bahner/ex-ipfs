defmodule IpfsElixir.Api do

    ## TODO: add (add_cmd, block, bootstrap, config, dag, dht, diag,
    ## files, key, name, object, pin, p2p,
    ## bitswap, filestore, shutdown, repo, resolve, stats, tar, file)

    import IpfsConnection

    
    # starts the ipfs daemon asynchronously on a elixir thread. 
    # recall this function with the start? of false and a flag of :normal or :kill to shutdown the process.
    # TODO: add ability to add options to the ipfs daemon command. 
    def start_shell(start? \\ true, flag \\ []) do
        {:ok, pid} = Task.start(fn -> System.cmd("ipfs", ["daemon"]) end) 
        if start? == false do
            pid |> shutdown(flag)
        else
            pid
        end
    end

    def add_cmd(file_path) do
        #file_data = file_path |> File.open!([:read, :binary]) |> IO.binread(:all)
        #req = HTTPoison.post!("http://localhost:5001/api/v0/add", {:multipart, [{:file, file_path, {["form-data"], [name: "\" file \"", filename: "\"" <> file_path <> "\""]},[]}]})
        req = setup_multipart_form(file_path)
        res = request_post("/add", req)
        res.body["Hash"]
    end

    def id do
        res = request_get("/id")
        res.body
        ##TODO: add extra args
    end

    def dns(arg) when is_bitstring(arg) do
        res = request_get("/dns?arg=", arg)
        res.body
    end
 
    ## TODO: add get_cmd for output, archive, compress and compression level
    def get_cmd(multihash) when is_bitstring(multihash) do
        request_get("/get?arg=", multihash)
        ##TODO add optional file writing funcitonality.
    end


    def cat_cmd(multihash) when is_bitstring(multihash) do
        request_get("/cat?arg=", multihash)
    end

    def swarm_peers do
        request_get("/swarm/peers")
    end

    def swarm_disconnect(multihash) when is_bitstring(multihash) do
        res = request("/swarm/disconnect?arg=", multihash)
        res.body
    end

    #Ls cmd TODO  Implement proper Json Format.
    def ls_cmd(multihash) when is_bitstring(multihash) do
        request_get("/ls?arg=", multihash)
    end

    ##Currently throws an error due to the size of JSON response.
    def repo_verify do
        request_get("/repo/verify")
    end

    def ping(id) do
        res = request("/ping?arg=", id)
        res.body
    end

    def log_level(subsys, level) do
        res = request_get("/log/level?arg=" <> subsys <> "&arg=" <> level)
        res.body
    end

    def log_ls do
        res = request_get("/log/ls")
        res.body
    end

    def log_tail do
        res = request_get("/log/tail")
        res.body
    end

    def mount do
        res = request_get("/mount")
        res.body
    end

    def pubsub_ls do
        res = request_get("/pubsub/ls")
        res.body
    end

    def pubsub_peers do
        res = request_get("/pubsub/pub")
        res.body
    end

    def pubsub_pub(topic, data) do
        res = request_get("/pubsub/pub?arg=" <> topic <> "&arg=" <> data)
        res.body
    end

    def pubsub_sub(topic) do
        res = request_get("/pubsub/sub?arg=", topic)
        res.body
    end

    def refs_local do
        res = request("/refs/local")
        res.body
    end

    #Update function  - takes in the current args for update.
    def update(args) when is_bitstring(args) do
        res = request_get("/update?arg=", args)
        res.body|> String.replace(~r/\r|\n/, "")
    end

    #version function - does not currently accept the optional arguments on golang client.
    def version(num \\ false, comm \\ false, repo \\ false, all \\ false) do
       res = request_get("/version?number=" <> to_string(num) <> "&commit=" <> to_string(comm) <> "&repo=" <> to_string(repo) <> "&all=" <> to_string(all) , "")
       res.body
    end

    def tour_list do
        request_get("/tour/list")
    end

    def tour_next do
        request_get("/tour/next")
    end

    def tour_restart do
        request_get("/tour/restart")
    end
    
    defp shutdown(pid, term \\ []) do
        Process.exit(pid, term)
    end

    defp build_url(conn, path) do
        "#{conn.protocol}://#{conn.host}:#{conn.port}/#{conn.base}/#{path}"
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

    defp request_post(path, data) do
        case post(path, data) do
            %Tesla.Env{status: 200, headers: headers, body: body} -> %{:headers => headers, :body => body}
            %Tesla.Env{status: 500, headers: headers, body: body} -> %{:headers => headers, :body => body}
            %Tesla.Env{status: 400, headers: headers, body: body} -> %{:headers => headers, :body => body}
            %Tesla.Env{status: 404, headers: headers} -> %{:headers=> headers, :error => "Error: 404 page not found."}
        end
    end

    defp request_get(path) do
        case get(path) do
            ## TODO: add more cases.
            %Tesla.Env{status: 200, headers: headers, body: body} -> %{:headers => headers, :body => body}
            %Tesla.Env{status: 500, headers: headers, body: body} -> %{:headers => headers, :body => body}
            %Tesla.Env{status: 400, headers: headers, body: body} -> %{:headers => headers, :body => body}
            %Tesla.Env{status: 404, headers: headers} -> %{:headers=> headers, :error => "Error: 404 page not found."}
        end
    end

    defp request_get(path, multihash) do
        case get(path <> multihash) do
            ## TODO: add more cases.
            %Tesla.Env{status: 200, headers: headers, body: body} -> %{:headers => headers, :body => body}
            %Tesla.Env{status: 500, headers: headers, body: body} -> %{:headers => headers, :body => body}
            %Tesla.Env{status: 400, headers: headers, body: body} -> %{:headers => headers, :body => body}
            %Tesla.Env{status: 404, headers: headers} -> %{:headers=> headers, :error => "Error: 404 page not found."}
        end
    end

    defp write_file(raw, multihash) do
      File.write(multihash, raw, [:write, :utf8])
    end
end
