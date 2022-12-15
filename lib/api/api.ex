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

  # Advanced commands
  alias MyspaceIPFS.Api.Advanced
  @spec mount :: {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate mount, to: Advanced, as: :mount
  @spec shutdown ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate shutdown, to: Advanced, as: :shutdown
  @spec resolve(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate resolve(multihash), to: Advanced, as: :resolve

  alias MyspaceIPFS.Api.Advanced.Filestore
  @spec filestore_dups ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate filestore_dups, to: Filestore, as: :dups
  @spec filestore_ls ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate filestore_ls, to: Filestore, as: :ls
  @spec filestore_verify ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate filestore_verify, to: Filestore, as: :verify

  alias MyspaceIPFS.Api.Advanced.Key
  @spec key_gen(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate key_gen(name), to: Key, as: :gen
  @spec key_list ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate key_list, to: Key, as: :list

  alias MyspaceIPFS.Api.Advanced.Name
  @spec name_publish(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate name_publish(multihash), to: Name, as: :publish
  @spec name_resolve ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate name_resolve, to: Name, as: :resolve

  alias MyspaceIPFS.Api.Advanced.Pin
  @spec pin_add(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate pin_add(multihash), to: Pin, as: :add
  @spec pin_ls(any) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate pin_ls(multihash), to: Pin, as: :ls
  @spec pin_rm(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate pin_rm(multihash), to: Pin, as: :rm

  alias MyspaceIPFS.Api.Advanced.Repo
  @spec repo_gc ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate repo_gc, to: Repo, as: :gc
  @spec repo_stat ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate repo_stat, to: Repo, as: :stat
  @spec repo_verify ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate repo_verify, to: Repo, as: :verify
  @spec repo_version ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate repo_version, to: Repo, as: :version

  alias MyspaceIPFS.Api.Advanced.Stats
  @spec stats_bitswap ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate stats_bitswap, to: Stats, as: :bitswap
  @spec stats_bw ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate stats_bw, to: Stats, as: :bw
  @spec stats_dht ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate stats_dht, to: Stats, as: :dht
  @spec stats_provide ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate stats_provide, to: Stats, as: :provide
  @spec stats_repo ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate stats_repo, to: Stats, as: :repo

  # Basic commands
  alias MyspaceIPFS.Api.Basic
  @spec add(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate add(file_path), to: Basic, as: :add
  @spec cat(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate cat(multihash), to: Basic, as: :cat
  @spec get(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate get(multihash), to: Basic, as: :get
  @spec ls(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate ls(multihash), to: Basic, as: :ls

  alias MyspaceIPFS.Api.Basic.Refs
  @spec refs_local ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate refs_local, to: Refs, as: :local
  @spec refs(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate refs(multihash), to: Refs, as: :refs

  # alias MyspaceIPFS.Api.Codecs.Cid
  # alias MyspaceIPFS.Api.Codes.Multilevel

  alias MyspaceIPFS.Api.Data.Block
  @spec block_get(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate block_get(multihash), to: Block, as: :get
  @spec block_put(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate block_put(file_path), to: Block, as: :put
  @spec block_rm(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate block_rm(multihash), to: Block, as: :rm
  @spec block_stat(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate block_stat(multihash), to: Block, as: :stat

  alias MyspaceIPFS.Api.Data.Dag
  @spec dag_get(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate dag_get(multihash), to: Dag, as: :get
  @spec dag_put(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate dag_put(file_path), to: Dag, as: :put

  alias MyspaceIPFS.Api.Data.Files
  @spec files_cp(binary, binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate files_cp(from, to), to: Files, as: :cp
  @spec files_flush ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate files_flush, to: Files, as: :flush
  @spec files_ls ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate files_ls, to: Files, as: :ls
  @spec files_mkdir(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate files_mkdir(path), to: Files, as: :mkdir
  @spec files_mv(binary, binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate files_mv(from, to), to: Files, as: :mv
  @spec files_read(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate files_read(path), to: Files, as: :read
  @spec files_rm(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate files_rm(path), to: Files, as: :rm
  @spec files_stat(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate files_stat(path), to: Files, as: :stat
  @spec files_write(binary, binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate files_write(path, data), to: Files, as: :write

  # Network commands
  alias MyspaceIPFS.Api.Network
  @spec id :: {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate id, to: Network, as: :id
  @spec ping(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate ping(peer_id), to: Network, as: :ping

  alias MyspaceIPFS.Api.Network.Bitswap
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

  alias MyspaceIPFS.Api.Network.Bootstrap
  @spec bootstrap_add_default ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate bootstrap_add_default, to: Bootstrap, as: :add_default
  @spec bootstrap_list ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate bootstrap_list, to: Bootstrap, as: :list
  @spec bootstrap_rm_all ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate bootstrap_rm_all, to: Bootstrap, as: :rm_all

  alias MyspaceIPFS.Api.Network.Dht
  @spec dht_query(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate dht_query(peer_id), to: Dht, as: :query

  alias MyspaceIPFS.Api.Network.PubSub
  @spec pubsub_ls ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate pubsub_ls, to: PubSub, as: :ls
  @spec pubsub_peers ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate pubsub_peers, to: PubSub, as: :peers
  @spec pubsub_pub(binary, binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate pubsub_pub(topic, data), to: PubSub, as: :pub
  @spec pubsub_sub(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate pubsub_sub(topic), to: PubSub, as: :sub

  # alias MyspaceIPFS.Api.Network.Routing

  alias MyspaceIPFS.Api.Network.Swarm
  @spec swarm_peers ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate swarm_peers, to: Swarm, as: :peers
  @spec swarm_addrs ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate swarm_addrs, to: Swarm, as: :addrs
  @spec swarm_addrs_local ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate swarm_addrs_local, to: Swarm, as: :addrs_local
  @spec swarm_addrs_listen ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate swarm_addrs_listen, to: Swarm, as: :addrs_listen
  @spec swarm_connect(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate swarm_connect(peer_id), to: Swarm, as: :connect
  @spec swarm_disconnect(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate swarm_disconnect(peer_id), to: Swarm, as: :disconnect
  @spec swarm_filters ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate swarm_filters, to: Swarm, as: :filters
  @spec swarm_filters_add(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate swarm_filters_add(addr), to: Swarm, as: :filters_add
  @spec swarm_filters_rm(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate swarm_filters_rm(addr), to: Swarm, as: :filters_rm

  # Tools commands
  alias MyspaceIPFS.Api.Tools
  @spec update(binary) :: binary
  defdelegate update(multihash), to: Tools, as: :update
  @spec version(any, any, any, any) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate version(num, comm, repo, all), to: Tools, as: :version

  alias MyspaceIPFS.Api.Tools.Commands
  @spec commands ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate commands, to: Commands, as: :commands
  @spec commands_completion(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate commands_completion(shell), to: Commands, as: :completion

  alias MyspaceIPFS.Api.Tools.Diag
  @spec diag_cmds ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate diag_cmds, to: Diag, as: :cmds
  @spec diag_cmds_clear ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate diag_cmds_clear, to: Diag, as: :cmds_clear
  @spec diag_cmds_set_time(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate diag_cmds_set_time(time), to: Diag, as: :cmds_set_time
  @spec diag_sys ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate diag_sys, to: Diag, as: :sys

  alias MyspaceIPFS.Api.Tools.Log
  @spec log_level(binary, binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate log_level(subsystem, level), to: Log, as: :level
  @spec log_ls ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate log_ls, to: Log, as: :ls
  @spec log_tail ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  defdelegate log_tail, to: Log, as: :tail
end
