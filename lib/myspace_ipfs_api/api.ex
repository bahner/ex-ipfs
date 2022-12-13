defmodule MyspaceIPFS.Api do
    @moduledoc """
  MyspaceIPFS.Api is where the main commands of the IPFS API reside.
  Alias this library and you can run the commands via Api.<cmd_name>.

        ## Examples

        iex> alias MyspaceIPFS.Api
        iex> Api.get_cmd("Multihash_key")
        <<0, 19, 148, 0, ... >>
  """

    import MyspaceIPFS.Connection

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
    @spec add_cmd(binary) :: any
    def add_cmd(file_path), do: setup_multipart_form(file_path) |> request_post("/add")

    @spec id :: any
    def id, do: request_get("/id")

    @spec dns(binary) :: any
    def dns(arg) when is_bitstring(arg), do: request_get("/dns?arg=", arg)

    ## TODO: add get_cmd for output, archive, compress and compression level
    @spec get_cmd(binary) :: any
    def get_cmd(multihash) when is_bitstring(multihash), do: request_get("/get?arg=", multihash)

    @spec cat_cmd(binary) :: any
    def cat_cmd(multihash) when is_bitstring(multihash), do: request_get("/cat?arg=", multihash)

    #Ls cmd TODO  Implement proper Json Format.
    @spec ls_cmd(binary) :: any
    def ls_cmd(multihash) when is_bitstring(multihash), do: request_get("/ls?arg=", multihash)

    @spec resolve(binary) :: any
    def resolve(multihash), do: request_get("/resolve?arg=", multihash)

    @spec bitswap_ledger(binary) :: any
    def bitswap_ledger(peer_id), do: request_get("/bitswap/ledger?arg=", peer_id)

    @spec bitswap_stat :: any
    def bitswap_stat, do: request_get("/bitswap/stat")

    @spec bitswap_unwant(binary) :: any
    def bitswap_unwant(keys), do: request_get("/bitswap/unwant?arg=", keys)

    @spec bitswap_wantlist(any) :: any
    def bitswap_wantlist(peer \\ "") do
        if peer != "" do
            request_get("/bitswap/wantlist?peer", peer)
        else
            request_get("/bitswap/wantlist")
        end
    end

    @spec block_get(binary) :: any
    def block_get(arg), do: request_get("/block/get?arg=", arg)

    @spec block_put(binary) :: any
    def block_put(file_path), do: setup_multipart_form(file_path) |> request_post("/block/put")

    @spec block_rm(binary) :: any
    def block_rm(multihash), do: request_get("/block/rm?arg=", multihash)

    @spec block_stat(binary) :: any
    def block_stat(multihash), do: request_get("/block/stat?arg=", multihash)

    @spec bootstrap_add_default :: any
    def bootstrap_add_default, do: request_get("/bootstrap/add/default")

    @spec bootstrap_list :: any
    def bootstrap_list, do: request_get("/bootstrap/list")

    @spec bootstrap_rm_all :: any
    def bootstrap_rm_all, do: request_get("bootstrap/rm/all")

    @spec config_edit :: any
    def config_edit, do: request_get("/config/edit")

    @spec config_replace(binary) :: any
    def config_replace(file_path), do: setup_multipart_form(file_path) |> request_post("/config/replace")

    @spec config_show :: any
    def config_show, do: request_get("/config/show")

    @spec dag_get(binary) :: any
    def dag_get(object), do: request_get("/dag/get?arg=", object)

    @spec dag_put(binary) :: any
    def dag_put(file_path), do: setup_multipart_form(file_path) |> request_post("/dag/put")

    @spec swarm_peers :: any
    def swarm_peers, do: request_get("/swarm/peers")

    @spec swarm_addrs_local :: any
    def swarm_addrs_local, do: request_get("/swarm/addrs/local")

    @spec swarm_connect(binary) :: any
    def swarm_connect(multihash), do: request_get("/swarm/connect?arg=", multihash)

    @spec swarm_filters_add(binary) :: any
    def swarm_filters_add(multihash), do: request_get("/swarm/filters/add?arg=", multihash)

    @spec swarm_filters_rm(binary) :: any
    def swarm_filters_rm(multihash), do: request_get("/swarm/filters/rm?arg=", multihash)

    @spec swarm_disconnect(any) :: none
    def swarm_disconnect(multihash) when is_bitstring(multihash), do: request("/swarm/disconnect?arg=", multihash)

    @spec commands :: any
    def commands, do: request_get("/commands")

    ##Currently throws an error due to the size of JSON response.
    @spec repo_verify :: any
    def repo_verify, do: request_get("/repo/verify")

    @spec repo_version :: any
    def repo_version, do: request_get("/repo/version")

    @spec repo_stat :: any
    def repo_stat, do: request_get("/repo/stat")

    @spec repo_gc :: any
    def repo_gc, do: request_get("/repo/gc")

    @spec repo_fsck :: any
    def repo_fsck, do: request_get("/repo/fsck")

    @spec ping(any) :: none
    def ping(id), do: request("/ping?arg=", id)

    @spec log_level(binary, binary) :: any
    def log_level(subsys, level), do: request_get("/log/level?arg=" <> subsys <> "&arg=" <> level)

    @spec log_ls :: any
    def log_ls, do: request_get("/log/ls")

    @spec log_tail :: any
    def log_tail, do: request_get("/log/tail")

    @spec mount :: any
    def mount, do: request_get("/mount")

    @spec pubsub_ls :: any
    def pubsub_ls, do: request_get("/pubsub/ls")

    @spec pubsub_peers :: any
    def pubsub_peers, do: request_get("/pubsub/pub")

    @spec pubsub_pub(binary, binary) :: any
    def pubsub_pub(topic, data), do: request_get("/pubsub/pub?arg=" <> topic <> "&arg=" <> data)

    @spec pubsub_sub(binary) :: any
    def pubsub_sub(topic), do: request_get("/pubsub/sub?arg=", topic)

    @spec refs_local :: any
    def refs_local, do: request_get("/refs/local")

    #Update function  - takes in the current args for update.
    @spec update(binary) :: binary
    def update(args) when is_bitstring(args) do
        res = request_get("/update?arg=", args)
        res.body|> String.replace(~r/\r|\n/, "")
    end

    #version function - does not currently accept the optional arguments on golang client.
    @spec version(any, any, any, any) :: any
    def version(num \\ false, comm \\ false, repo \\ false, all \\ false) do
       request_get("/version?number=" <> to_string(num) <> "&commit=" <> to_string(comm) <> "&repo=" <> to_string(repo) <> "&all=" <> to_string(all) , "")
    end

    @spec tour_list :: any
    def tour_list, do: request_get("/tour/list")

    @spec tour_next :: any
    def tour_next, do: request_get("/tour/next")

    @spec tour_restart :: any
    def tour_restart, do: request_get("/tour/restart")

    @spec dht_find_peer(binary) :: any
    def dht_find_peer(arg), do: request_get("/dht/findpeer?arg=", arg)

    @spec dht_find_provs(binary) :: any
    def dht_find_provs(arg), do: request_get("/dht/findprovs?arg=", arg)

    @spec dht_get(binary) :: any
    def dht_get(arg), do: request_get("/dht/get?arg=", arg)

    @spec dht_provide(binary) :: any
    def dht_provide(arg), do: request_get("/dht/provide?arg=", arg)

    @spec dht_put(binary, binary) :: any
    def dht_put(key, value), do: request_get("/dht/put?arg=" <> key <> "&arg=" <> value)

    @spec dht_query(binary) :: any
    def dht_query(peer_id), do: request_get("/dht/query?arg=", peer_id)

    @spec cmds_clear :: any
    def cmds_clear, do: request_get("/cmds/clear")

    @spec cmds_set_time(binary) :: any
    def cmds_set_time(time), do: request_get("/cmds/set-time?arg=", time)

    @spec diag_net(any) :: any
    def diag_net(vis \\ "") do
        if vis != "" do
            request_get("/diag/net?vis=", vis)
        else
            request_get("/diag/net")
        end
    end

    @spec diag_sys :: any
    def diag_sys, do: request_get("/diag/sys")

    @spec key_gen(binary) :: any
    def key_gen(key), do: request_get("/key/gen?arg=", key)

    @spec key_list :: any
    def key_list, do: request_get("/key/list")

    @spec object_data(binary) :: any
    def object_data(multihash), do: request_get("/object/data?arg=", multihash)

    @spec object_diff(binary, binary) :: any
    def object_diff(obj_a, obj_b), do: request_get("/object/diff?arg=" <> obj_a <> "&arg=" <> obj_b)

    @spec object_get(binary) :: any
    def object_get(multihash), do: request_get("/object/get?arg=", multihash)

    @spec object_links(binary) :: any
    def object_links(multihash), do: request_get("/object/links?arg=", multihash)

    @spec object_new(any) :: any
    def object_new(template \\ "") do
        if template != "" do
            request_get("/object/new?arg=", template)
        else
            request_get("/object/new")
        end
    end

    @spec object_patch_add_link(binary, binary, binary) :: any
    def object_patch_add_link(multihash, name, object), do: request_get("/object/patch/add-link?arg=" <> multihash <>
                                                                   "&arg=" <> name <> "&arg=" <> object)
    @spec object_patch_append_data(binary, binary) :: any
    def object_patch_append_data(multihash, data) do
        setup_multipart_form(data) |> request_post("/object/patch/append-data?arg=" <> multihash)
    end

    @spec object_patch_rm_link(binary, binary) :: any
    def object_patch_rm_link(multihash, name), do: request_get("/object/patch/rm-link?arg=" <> multihash <> "&arg=", name)

    @spec object_patch_set_data(binary, binary) :: any
    def object_patch_set_data(multihash, data) do
        setup_multipart_form(data) |> request_post("/object/patch/set-data?arg=" <> multihash)
    end

    @spec object_put(binary) :: any
    def object_put(data), do: setup_multipart_form(data) |> request_post("/object/put")

    @spec object_stat(binary) :: any
    def object_stat(multihash), do: request_get("/object/stat?arg=", multihash)

    @spec pin_add(binary) :: any
    def pin_add(object), do: request_get("/pin/add?arg=", object)

    @spec pin_ls(any) :: any
    def pin_ls(object \\ "") do
        if object != "" do
            request_get("/pin/ls?arg=", object)
        else
            request_get("/pin/ls")
        end
    end

    @spec pin_rm(binary) :: any
    def pin_rm(object), do: request_get("/pin/rm?arg=", object)

    @spec file_ls(binary) :: any
    def file_ls(object), do: request_get("/file/ls?arg=", object)

    @spec files_cp(binary, binary) :: any
    def files_cp(source, dest), do: request_get("/files/cp?arg=" <> source <>  "&arg=" <> dest)

    @spec files_flush :: any
    def files_flush, do: request_get("/files/flush")

    @spec files_ls :: any
    def files_ls, do: request_get("/files/ls")

    @spec files_mkdir(binary) :: any
    def files_mkdir(path), do: request_get("/files/mkdir?arg=", path)

    @spec files_mv(binary, binary) :: any
    def files_mv(source, dest), do: request_get("/files/mv?arg=" <> source <> "&arg=" <> dest)

    @spec files_read(binary) :: any
    def files_read(path), do: request_get("/files/read?arg=", path)

    @spec files_rm(binary) :: any
    def files_rm(path), do: request_get("/files/rm?arg=", path)

    @spec files_stat(binary) :: any
    def files_stat(path), do: request_get("/files/stat?arg=", path)

    @spec files_write(binary, binary) :: any
    def files_write(path, data), do: setup_multipart_form(data) |> request_post("/files/write?arg=" <> path)

    @spec filestore_dups :: any
    def filestore_dups, do: request_get("/filestore/dups")

    @spec filestore_ls :: any
    def filestore_ls, do: request_get("/filestore/ls")

    @spec filestore_verify :: any
    def filestore_verify, do: request_get("/filestore/verify")

    @spec name_publish(binary) :: any
    def name_publish(path), do: request_get("/name/publish?arg=", path)

    @spec name_resolve :: any
    def name_resolve, do: request_get("/name/resolve")

    @spec tar_add(binary) :: any
    def tar_add(file), do: setup_multipart_form(file) |> request_post("/tar/add")

    @spec tar_cat(binary) :: any
    def tar_cat(path), do: request_get("/tar/cat?arg=", path)

    @spec stats_bitswap :: any
    def stats_bitswap, do: request_get("/stats/bitswap")

    @spec stats_bw :: any
    def stats_bw, do: request_get("/stats/bw")

    @spec stats_repo :: any
    def stats_repo, do: request_get("/stats/repo")

    defp shutdown(pid, term) do
        Process.exit(pid, term)
    end

    defp request_post(file, path) do
        case post(path, file) do
            {:ok, result} -> result |> Map.fetch!(:body)
            {:error, reason} -> reason
        end
    end

    defp request_get(path) do
        post(path, "")
        case post(path, "") do
            {:ok, result} -> result |> Map.fetch!(:body)
            {:error, reason} -> reason
        end
    end

    defp request_get(path, arg) do
        case post(path <> arg, "") do
            {:ok, result} -> result |> Map.fetch!(:body)
            {:error, reason} -> reason
        end
    end

    # defp write_file(raw, multihash) do
    #   File.write(multihash, raw, [:write, :utf8])
    # end
end
