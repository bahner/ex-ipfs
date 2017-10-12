defmodule IpfsElixir.Api do

    ## TODO: add (files, name, object, pin, p2p,
    ##  filestore, shutdown, repo, resolve, stats, tar, file)

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


    # TODO: add various flags to the add_cmd. 
    def add_cmd(file_path) do
        #file_data = file_path |> File.open!([:read, :binary]) |> IO.binread(:all)
        setup_multipart_form(file_path) |> request_post("/add")
    end

    def id do
        request_get("/id")
        ##TODO: add extra args
    end

    def dns(arg) when is_bitstring(arg) do
        request_get("/dns?arg=", arg)
    end
 
    ## TODO: add get_cmd for output, archive, compress and compression level
    def get_cmd(multihash) when is_bitstring(multihash) do
        request_get("/get?arg=", multihash)
        ##TODO add optional file writing funcitonality.
    end

    def cat_cmd(multihash) when is_bitstring(multihash) do
        request_get("/cat?arg=", multihash)
    end

    #Ls cmd TODO  Implement proper Json Format.
    def ls_cmd(multihash) when is_bitstring(multihash) do
        request_get("/ls?arg=", multihash)
    end

    def bitswap_ledger(peer_id) do
        request_get("/bitswap/ledger?arg=", peer_id)
    end

    def bitswap_stat do
        request_get("/bitswap/stat")
    end 

    def bitswap_unwant(keys) do
        request_get("/bitswap/unwant?arg=", keys)
    end

    def bitswap_wantlist(peer \\ "") do
        if peer != "" do
            request_get("/bitswap/wantlist?peer", peer)
        else    
            request_get("/bitswap/wantlist")
        end
    end

    def block_get(arg) do
        request_get("/block/get?arg=", arg)
    end

    def block_put(file_path) do
        setup_multipart_form(file_path) |> request_post("/block/put")
    end

    def block_rm(multihash) do
        request_get("/block/rm?arg=", multihash)
    end

    def block_stat(multihash) do
        request_get("/block/stat?arg=", multihash)
    end

    def bootstrap_add_default do
        request_get("/bootstrap/add/default")
    end

    def bootstrap_list do
        request_get("/bootstrap/list")
    end

    def bootstrap_rm_all do
        request_get("bootstrap/rm/all")
    end

    def config_edit do
        request_get("/config/edit")
    end

    def config_replace(file_path) do
        setup_multipart_form(file_path) |> request_post("/config/replace")        
    end

    def config_show do
        request_get("/config/show")
    end

    def dag_get(object) do
        request_get("/dag/get?arg=", object)
    end

    def dag_put(file_path) do
        setup_multipart_form(file_path) |> request_post("/dag/put")
    end

    def swarm_peers do
        request_get("/swarm/peers")
    end

    def swarm_disconnect(multihash) when is_bitstring(multihash) do
        request("/swarm/disconnect?arg=", multihash)
    end

    def commands do
        request_get("/commands")
    end

    ##Currently throws an error due to the size of JSON response.
    def repo_verify do
        request_get("/repo/verify")
    end

    def ping(id) do
        request("/ping?arg=", id)
    end

    def log_level(subsys, level) do
        request_get("/log/level?arg=" <> subsys <> "&arg=" <> level) 
    end

    def log_ls do
        request_get("/log/ls")
    end

    def log_tail do
        request_get("/log/tail")
    end

    def mount do
        request_get("/mount")
    end

    def pubsub_ls do
        request_get("/pubsub/ls")
    end

    def pubsub_peers do
        request_get("/pubsub/pub")
    end

    def pubsub_pub(topic, data) do
        request_get("/pubsub/pub?arg=" <> topic <> "&arg=" <> data)
    end

    def pubsub_sub(topic) do
        request_get("/pubsub/sub?arg=", topic)
    end

    def refs_local do
        request_get("/refs/local")
    end

    #Update function  - takes in the current args for update.
    def update(args) when is_bitstring(args) do
        res = request_get("/update?arg=", args)
        res.body|> String.replace(~r/\r|\n/, "")
    end

    #version function - does not currently accept the optional arguments on golang client.
    def version(num \\ false, comm \\ false, repo \\ false, all \\ false) do
       request_get("/version?number=" <> to_string(num) <> "&commit=" <> to_string(comm) <> "&repo=" <> to_string(repo) <> "&all=" <> to_string(all) , "")
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

    def dht_find_peer(arg) do
        request_get("/dht/findpeer?arg=", arg)
    end

    def dht_find_provs(arg) do
        request_get("/dht/findprovs?arg=", arg)
    end

    def dht_get(arg) do
        request_get("/dht/get?arg=", arg)
    end

    def dht_provide(arg) do
        request_get("/dht/provide?arg=", arg)
    end

    def dht_put(key, value) do  
        request_get("/dht/put?arg=" <> key <> "&arg=" <> value)
    end

    def dht_query(peer_id) do
        request_get("/dht/query?arg=", peer_id)
    end

    def cmds_clear do
        request_get("/cmds/clear")
    end

    def cmds_set_time(time) do
        request_get("/cmds/set-time?arg=", time)
    end

    def diag_net(vis \\ "") do
        if vis != "" do
            request_get("/diag/net?vis=", vis)
        else
            request_get("/diag/net")
        end
    end

    def diag_sys do
        request_get("/diag/sys")
    end

    def key_gen(key) do
        request_get("/key/gen?arg=", key)
    end

    def key_list do
        request_get("/key/list")
    end
    
    defp shutdown(pid, term \\ []) do
        Process.exit(pid, term)
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


    defp request_post(file, path) do
        case post(path, file) do
            %Tesla.Env{status: 200, body: body} -> body
            %Tesla.Env{status: 500, body: body} -> body
            %Tesla.Env{status: 400, body: body} -> body
            %Tesla.Env{status: 404} -> "Error: 404 page not found."
        end
    end

    defp request_get(path) do
        case get(path) do
            ## TODO: add more cases.
            %Tesla.Env{status: 200, body: body} -> body
            %Tesla.Env{status: 500, body: body} -> body
            %Tesla.Env{status: 400, body: body} -> body
            %Tesla.Env{status: 404} -> "Error: 404 page not found."
        end
    end

    defp request_get(path, arg) do
        case get(path <> arg) do
            ## TODO: add more cases.
            %Tesla.Env{status: 200, body: body} -> body
            %Tesla.Env{status: 500, body: body} -> body
            %Tesla.Env{status: 400, body: body} -> body
            %Tesla.Env{status: 404} -> "Error: 404 page not found."
        end
    end

    defp write_file(raw, multihash) do
      File.write(multihash, raw, [:write, :utf8])
    end
end
