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
  defdelegate mount, to: Advanced, as: :mount

  defdelegate shutdown, to: Advanced, as: :shutdown

  defdelegate resolve(multihash), to: Advanced, as: :resolve

  alias MyspaceIPFS.Api.Advanced.Filestore

  defdelegate filestore_dups, to: Filestore, as: :dups

  defdelegate filestore_ls, to: Filestore, as: :ls

  defdelegate filestore_verify, to: Filestore, as: :verify

  alias MyspaceIPFS.Api.Advanced.Key

  defdelegate key_gen(name), to: Key, as: :gen

  defdelegate key_list, to: Key, as: :list

  alias MyspaceIPFS.Api.Advanced.Name

  defdelegate name_publish(multihash), to: Name, as: :publish

  defdelegate name_resolve, to: Name, as: :resolve

  alias MyspaceIPFS.Api.Advanced.Pin

  defdelegate pin_add(multihash), to: Pin, as: :add

  defdelegate pin_ls(multihash), to: Pin, as: :ls

  defdelegate pin_rm(multihash), to: Pin, as: :rm

  alias MyspaceIPFS.Api.Advanced.Repo

  defdelegate repo_gc, to: Repo, as: :gc

  defdelegate repo_stat, to: Repo, as: :stat

  defdelegate repo_verify, to: Repo, as: :verify

  defdelegate repo_version, to: Repo, as: :version

  alias MyspaceIPFS.Api.Advanced.Stats

  defdelegate stats_bitswap, to: Stats, as: :bitswap

  defdelegate stats_bw, to: Stats, as: :bw

  defdelegate stats_dht, to: Stats, as: :dht

  defdelegate stats_provide, to: Stats, as: :provide

  defdelegate stats_repo, to: Stats, as: :repo

  # Basic commands
  alias MyspaceIPFS.Api.Basic

  defdelegate add(file_path), to: Basic, as: :add

  defdelegate cat(multihash), to: Basic, as: :cat

  defdelegate get(multihash), to: Basic, as: :get

  defdelegate ls(multihash), to: Basic, as: :ls

  defdelegate init, to: Basic, as: :init

  alias MyspaceIPFS.Api.Basic.Refs

  defdelegate refs_local, to: Refs, as: :local

  defdelegate refs(multihash, format, edges, unique, recursive, max_depth), to: Refs, as: :refs

  # alias MyspaceIPFS.Api.Codecs.Cid
  # alias MyspaceIPFS.Api.Codes.Multilevel

  alias MyspaceIPFS.Api.Data.Block

  defdelegate block_get(multihash), to: Block, as: :get

  defdelegate block_put(file_path), to: Block, as: :put

  defdelegate block_rm(multihash), to: Block, as: :rm

  defdelegate block_stat(multihash), to: Block, as: :stat

  alias MyspaceIPFS.Api.Data.Dag

  defdelegate dag_get(multihash), to: Dag, as: :get

  defdelegate dag_put(file_path), to: Dag, as: :put

  alias MyspaceIPFS.Api.Data.Files

  defdelegate files_cp(from, to), to: Files, as: :cp

  defdelegate files_flush, to: Files, as: :flush

  defdelegate files_ls, to: Files, as: :ls

  defdelegate files_mkdir(path), to: Files, as: :mkdir

  defdelegate files_mv(from, to), to: Files, as: :mv

  defdelegate files_read(path), to: Files, as: :read

  defdelegate files_rm(path), to: Files, as: :rm

  defdelegate files_stat(path), to: Files, as: :stat

  defdelegate files_write(path, data), to: Files, as: :write

  # Network commands
  alias MyspaceIPFS.Api.Network
  defdelegate id, to: Network, as: :id

  defdelegate ping(peer_id), to: Network, as: :ping

  alias MyspaceIPFS.Api.Network.Bitswap

  defdelegate bitswap_ledger(peer_id), to: Bitswap, as: :ledger

  defdelegate bitswap_stat(verbose, human), to: Bitswap, as: :stat

  defdelegate bitswap_wantlist(peer), to: Bitswap, as: :wantlist

  defdelegate bitswap_reprovide, to: Bitswap, as: :reprovide

  alias MyspaceIPFS.Api.Network.Bootstrap

  defdelegate bootstrap_add_default, to: Bootstrap, as: :add_default

  defdelegate bootstrap_list, to: Bootstrap, as: :list

  defdelegate bootstrap_rm_all, to: Bootstrap, as: :rm_all

  alias MyspaceIPFS.Api.Network.Dht

  defdelegate dht_query(peer_id), to: Dht, as: :query

  alias MyspaceIPFS.Api.Network.PubSub

  defdelegate pubsub_ls, to: PubSub, as: :ls

  defdelegate pubsub_peers, to: PubSub, as: :peers

  defdelegate pubsub_pub(topic, data), to: PubSub, as: :pub

  defdelegate pubsub_sub(topic), to: PubSub, as: :sub

  # alias MyspaceIPFS.Api.Network.Routing

  alias MyspaceIPFS.Api.Network.Swarm

  defdelegate swarm_peers, to: Swarm, as: :peers

  defdelegate swarm_addrs, to: Swarm, as: :addrs

  defdelegate swarm_addrs_local, to: Swarm, as: :addrs_local

  defdelegate swarm_addrs_listen, to: Swarm, as: :addrs_listen

  defdelegate swarm_connect(peer_id), to: Swarm, as: :connect

  defdelegate swarm_disconnect(peer_id), to: Swarm, as: :disconnect

  defdelegate swarm_filters, to: Swarm, as: :filters

  defdelegate swarm_filters_add(addr), to: Swarm, as: :filters_add

  defdelegate swarm_filters_rm(addr), to: Swarm, as: :filters_rm

  # Tools commands
  alias MyspaceIPFS.Api.Tools
  defdelegate update(multihash), to: Tools, as: :update

  defdelegate version(num, comm, repo, all), to: Tools, as: :version

  alias MyspaceIPFS.Api.Tools.Commands

  defdelegate commands, to: Commands, as: :commands

  defdelegate commands_completion(shell), to: Commands, as: :completion

  alias MyspaceIPFS.Api.Tools.Diag

  defdelegate diag_cmds, to: Diag, as: :cmds

  defdelegate diag_cmds_clear, to: Diag, as: :cmds_clear

  defdelegate diag_cmds_set_time(time), to: Diag, as: :cmds_set_time

  defdelegate diag_sys, to: Diag, as: :sys

  alias MyspaceIPFS.Api.Tools.Log

  defdelegate log_level(subsystem, level), to: Log, as: :level

  defdelegate log_ls, to: Log, as: :ls

  defdelegate log_tail, to: Log, as: :tail
end
