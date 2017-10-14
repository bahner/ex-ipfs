defmodule IpfsElixir.Api do
    @moduledoc """
  IpfsElixir.Api is where the main commands of the IPFS API reside. 
  Alias this library and you can run the commands via Api.<cmd_name>.  

        ## Examples

        iex> alias IpfsElixir.Api
        iex> Api.get_cmd("Multihash_key")
        <<0, 19, 148, 0, ... >>
  """

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
    def add_cmd(file_path), do: setup_multipart_form(file_path) |> request_post("/add")

    def id, do: request_get("/id")
        
    def dns(arg) when is_bitstring(arg), do: request_get("/dns?arg=", arg)

    ## TODO: add get_cmd for output, archive, compress and compression level
    def get_cmd(multihash) when is_bitstring(multihash), do: request_get("/get?arg=", multihash)

    def cat_cmd(multihash) when is_bitstring(multihash), do: request_get("/cat?arg=", multihash)

    #Ls cmd TODO  Implement proper Json Format.
    def ls_cmd(multihash) when is_bitstring(multihash), do: request_get("/ls?arg=", multihash)

    def resolve(multihash), do: request_get("/resolve?arg=", multihash)

    def bitswap_ledger(peer_id), do: request_get("/bitswap/ledger?arg=", peer_id)
        
    def bitswap_stat, do: request_get("/bitswap/stat")

    def bitswap_unwant(keys), do: request_get("/bitswap/unwant?arg=", keys)

    def bitswap_wantlist(peer \\ "") do
        if peer != "" do
            request_get("/bitswap/wantlist?peer", peer)
        else    
            request_get("/bitswap/wantlist")
        end
    end

    def block_get(arg), do: request_get("/block/get?arg=", arg)  

    def block_put(file_path), do: setup_multipart_form(file_path) |> request_post("/block/put")

    def block_rm(multihash), do: request_get("/block/rm?arg=", multihash)

    def block_stat(multihash), do: request_get("/block/stat?arg=", multihash)

    def bootstrap_add_default, do: request_get("/bootstrap/add/default")
        
    def bootstrap_list, do: request_get("/bootstrap/list")
        
    def bootstrap_rm_all, do: request_get("bootstrap/rm/all")

    def config_edit, do: request_get("/config/edit")

    def config_replace(file_path), do: setup_multipart_form(file_path) |> request_post("/config/replace")        

    def config_show, do: request_get("/config/show")

    def dag_get(object), do: request_get("/dag/get?arg=", object)

    def dag_put(file_path), do: setup_multipart_form(file_path) |> request_post("/dag/put")

    def swarm_peers, do: request_get("/swarm/peers")

    def swarm_addrs_local, do: request_get("/swarm/addrs/local")

    def swarm_connect(multihash), do: request_get("/swarm/connect?arg=", multihash)

    def swarm_filters_add(multihash), do: request_get("/swarm/filters/add?arg=", multihash)

    def swarm_filters_rm(multihash), do: request_get("/swarm/filters/rm?arg=", multihash)

    def swarm_disconnect(multihash) when is_bitstring(multihash), do: request("/swarm/disconnect?arg=", multihash)

    def commands, do: request_get("/commands")

    ##Currently throws an error due to the size of JSON response.
    def repo_verify, do: request_get("/repo/verify")

    def repo_version, do: request_get("/repo/version")

    def repo_stat, do: request_get("/repo/stat")

    def repo_gc, do: request_get("/repo/gc")

    def repo_fsck, do: request_get("/repo/fsck")

    def ping(id), do: request("/ping?arg=", id)

    def log_level(subsys, level), do: request_get("/log/level?arg=" <> subsys <> "&arg=" <> level) 
        
    def log_ls, do: request_get("/log/ls")

    def log_tail, do: request_get("/log/tail")

    def mount, do: request_get("/mount")

    def pubsub_ls, do: request_get("/pubsub/ls")

    def pubsub_peers, do: request_get("/pubsub/pub")

    def pubsub_pub(topic, data), do: request_get("/pubsub/pub?arg=" <> topic <> "&arg=" <> data)

    def pubsub_sub(topic), do: request_get("/pubsub/sub?arg=", topic)

    def refs_local, do: request_get("/refs/local")

    #Update function  - takes in the current args for update.
    def update(args) when is_bitstring(args) do
        res = request_get("/update?arg=", args)
        res.body|> String.replace(~r/\r|\n/, "")
    end

    #version function - does not currently accept the optional arguments on golang client.
    def version(num \\ false, comm \\ false, repo \\ false, all \\ false) do
       request_get("/version?number=" <> to_string(num) <> "&commit=" <> to_string(comm) <> "&repo=" <> to_string(repo) <> "&all=" <> to_string(all) , "")
    end

    def tour_list, do: request_get("/tour/list")

    def tour_next, do: request_get("/tour/next")

    def tour_restart, do: request_get("/tour/restart")
        
    def dht_find_peer(arg), do: request_get("/dht/findpeer?arg=", arg)

    def dht_find_provs(arg), do: request_get("/dht/findprovs?arg=", arg)
        
    def dht_get(arg), do: request_get("/dht/get?arg=", arg)
        
    def dht_provide(arg), do: request_get("/dht/provide?arg=", arg)
        
    def dht_put(key, value), do: request_get("/dht/put?arg=" <> key <> "&arg=" <> value)  

    def dht_query(peer_id), do: request_get("/dht/query?arg=", peer_id)
        
    def cmds_clear, do: request_get("/cmds/clear")

    def cmds_set_time(time), do: request_get("/cmds/set-time?arg=", time)

    def diag_net(vis \\ "") do
        if vis != "" do
            request_get("/diag/net?vis=", vis)
        else
            request_get("/diag/net")
        end
    end

    def diag_sys, do: request_get("/diag/sys")
        
    def key_gen(key), do: request_get("/key/gen?arg=", key)
        
    def key_list, do: request_get("/key/list")

    def object_data(multihash), do: request_get("/object/data?arg=", multihash)

    def object_diff(obj_a, obj_b), do: request_get("/object/diff?arg=" <> obj_a <> "&arg=" <> obj_b)
  
    def object_get(multihash), do: request_get("/object/get?arg=", multihash)
        
    def object_links(multihash), do: request_get("/object/links?arg=", multihash)
        
    def object_new(template \\ "") do
        if template != "" do
            request_get("/object/new?arg=", template)
        else
            request_get("/object/new")
        end
    end

    def object_patch_add_link(multihash, name, object), do: request_get("/object/patch/add-link?arg=" <> multihash <> 
                                                                   "&arg=" <> name <> "&arg=" <> object)
    def object_patch_append_data(multihash, data) do
        setup_multipart_form(data) |> request_post("/object/patch/append-data?arg=" <> multihash)
    end

    def object_patch_rm_link(multihash, name), do: request_get("/object/patch/rm-link?arg=" <> multihash <> "&arg=", name)

    def object_patch_set_data(multihash, data) do
        setup_multipart_form(data) |> request_post("/object/patch/set-data?arg=" <> multihash)
    end

    def object_put(data), do: setup_multipart_form(data) |> request_post("/object/put")

    def object_stat(multihash), do: request_get("/object/stat?arg=", multihash)

    def pin_add(object), do: request_get("/pin/add?arg=", object)

    def pin_ls(object \\ "") do
        if object != "" do
            request_get("/pin/ls?arg=", object)
        else
            request_get("/pin/ls")
        end 
    end
    
    def pin_rm(object), do: request_get("/pin/rm?arg=", object)

    def file_ls(object), do: request_get("/file/ls?arg=", object)

    def files_cp(source, dest), do: request_get("/files/cp?arg=" <> source <>  "&arg=" <> dest)
    
    def files_flush, do: request_get("/files/flush")

    def files_ls, do: request_get("/files/ls")

    def files_mkdir(path), do: request_get("/files/mkdir?arg=", path)

    def files_mv(source, dest), do: request_get("/files/mv?arg=" <> source <> "&arg=" <> dest)

    def files_read(path), do: request_get("/files/read?arg=", path)

    def files_rm(path), do: request_get("/files/rm?arg=", path)

    def files_stat(path), do: request_get("/files/stat?arg=", path)

    def files_write(path, data), do: setup_multipart_form(data) |> request_post("/files/write?arg=" <> path)

    def filestore_dups, do: request_get("/filestore/dups")

    def filestore_ls, do: request_get("/filestore/ls")

    def filestore_verify, do: request_get("/filestore/verify")

    def name_publish(path), do: request_get("/name/publish?arg=", path) 

    def name_resolve, do: request_get("/name/resolve")

    def tar_add(file), do: setup_multipart_form(file) |> request_post("/tar/add")

    def tar_cat(path), do: request_get("/tar/cat?arg=", path)

    def stats_bitswap, do: request_get("/stats/bitswap")

    def stats_bw, do: request_get("/stats/bw")

    def stats_repo, do: request_get("/stats/repo")

    defp shutdown(pid, term \\ []) do
        Process.exit(pid, term)
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
