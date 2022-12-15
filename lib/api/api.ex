defmodule MyspaceIPFS.Api do
  @moduledoc """
  MyspaceIPFS.Api is where the main commands of the IPFS API reside.
  Alias this library and you can run the commands via Api.<cmd_name>.

        ## Examples

        iex> alias MyspaceIPFS.API, as: Api
        iex> Api.get("Multihash_key")
        <<0, 19, 148, 0, ... >>
  """

  # TODO: add ability to add options to the ipfs daemon command.
  # TODO: read ipfs config from config file.
  # TODO: handle experimental and deprecated here.
  @spec start_shell(any, any) :: true | pid
  def start_shell(start? \\ true, flag \\ []) do
    {:ok, pid} = Task.start(fn -> System.cmd("ipfs", ["daemon"]) end)

    if start? == false do
      pid |> shutdown(flag)
    else
      pid
    end
  end

  defp shutdown(pid, term) do
    Process.exit(pid, term)
  end

  alias MyspaceIPFS.Api.Bitswap
  @spec bitswap_ledger(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate bitswap_ledger(peer_id), to: Bitswap, as: :ledger
  @spec bitswap_stat(boolean, boolean) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate bitswap_stat(verbose, human), to: Bitswap, as: :stat
  @spec bitswap_wantlist(any) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate bitswap_wantlist(peer), to: Bitswap, as: :wantlist
  @spec bitswap_reprovide ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate bitswap_reprovide, to: Bitswap, as: :reprovide

  alias MyspaceIPFS.Api.Block
  defdelegate block_get(multihash), to: Block, as: :get
  defdelegate block_put(file_path), to: Block, as: :put
  defdelegate block_rm(multihash), to: Block, as: :rm
  defdelegate block_stat(multihash), to: Block, as: :stat

  alias MyspaceIPFS.Api.Bootstrap
  defdelegate bootstrap_add_default, to: Bootstrap, as: :add_default
  defdelegate bootstrap_list, to: Bootstrap, as: :list
  defdelegate bootstrap_rm_all, to: Bootstrap, as: :rm_all

  # alias MyspaceIPFS.Api.Cid
  alias MyspaceIPFS.Api.Commands
  defdelegate commands, to: Commands, as: :commands
  defdelegate commands_completion(shell), to: Commands, as: :completion

  alias MyspaceIPFS.Api.Dag
  defdelegate dag_get(multihash), to: Dag, as: :get
  defdelegate dag_put(file_path), to: Dag, as: :put

  alias MyspaceIPFS.Api.Dht
  defdelegate dht_query(peer_id), to: Dht, as: :query

  alias MyspaceIPFS.Api.Main
  defdelegate id, to: Main, as: :id
  defdelegate mount, to: Main, as: :mount
  defdelegate ping(peer_id), to: Main, as: :ping
  defdelegate shutdown, to: Main, as: :shutdown
  defdelegate add(file_path), to: Main, as: :add
  defdelegate cat(multihash), to: Main, as: :cat
  defdelegate get(multihash), to: Main, as: :get
  defdelegate ls(multihash), to: Main, as: :ls
  defdelegate resolve(multihash), to: Main, as: :resolve
  defdelegate update(multihash), to: Main, as: :update
  defdelegate version(num, comm, repo, all), to: Main, as: :version

  alias MyspaceIPFS.Api.Filestore
  defdelegate filestore_dups, to: Filestore, as: :dups
  defdelegate filestore_ls, to: Filestore, as: :ls
  defdelegate filestore_verify, to: Filestore, as: :verify

  alias MyspaceIPFS.Api.Key
  defdelegate key_gen(name), to: Key, as: :gen
  defdelegate key_list, to: Key, as: :list

  alias MyspaceIPFS.Api.Log
  defdelegate log_level(subsystem, level), to: Log, as: :level
  defdelegate log_ls, to: Log, as: :ls
  defdelegate log_tail, to: Log, as: :tail

  # alias MyspaceIPFS.Api.Multilevel
  alias MyspaceIPFS.Api.Name
  defdelegate name_publish(multihash), to: Name, as: :publish
  defdelegate name_resolve, to: Name, as: :resolve

  alias MyspaceIPFS.Api.Pin

  defdelegate pin_add(multihash), to: Pin, as: :add
  defdelegate pin_ls(multihash), to: Pin, as: :ls
  defdelegate pin_rm(multihash), to: Pin, as: :rm

  alias MyspaceIPFS.Api.PubSub
  defdelegate pubsub_ls, to: PubSub, as: :ls
  defdelegate pubsub_peers, to: PubSub, as: :peers
  defdelegate pubsub_pub(topic, data), to: PubSub, as: :pub
  defdelegate pubsub_sub(topic), to: PubSub, as: :sub

  alias MyspaceIPFS.Api.Refs
  defdelegate refs_local, to: Refs, as: :local

  alias MyspaceIPFS.Api.Repo
  defdelegate repo_gc, to: Repo, as: :gc
  defdelegate repo_stat, to: Repo, as: :stat
  defdelegate repo_verify, to: Repo, as: :verify
  defdelegate repo_version, to: Repo, as: :version
  #   alias MyspaceIPFS.Api.Routing

  alias MyspaceIPFS.Api.Stats
  defdelegate stats_bitswap, to: Stats, as: :bitswap
  defdelegate stats_bw, to: Stats, as: :bw
  defdelegate stats_dht, to: Stats, as: :dht
  defdelegate stats_provide, to: Stats, as: :provide
  defdelegate stats_repo, to: Stats, as: :repo

  alias MyspaceIPFS.Api.Swarm
  defdelegate swarm_peers, to: Swarm, as: :peers
  defdelegate swarm_addrs, to: Swarm, as: :addrs
  defdelegate swarm_addrs_local, to: Swarm, as: :addrs_local
  defdelegate swarm_addrs_listen, to: Swarm, as: :addrs_listen
  defdelegate swarm_connect(peer_id), to: Swarm, as: :connect
  defdelegate swarm_disconnect(peer_id), to: Swarm, as: :disconnect
  defdelegate swarm_filters, to: Swarm, as: :filters
  defdelegate swarm_filters_add(addr), to: Swarm, as: :filters_add
  defdelegate swarm_filters_rm(addr), to: Swarm, as: :filters_rm
end
