defmodule MyspaceIPFS.Repo do
  @moduledoc """
  MyspaceIPFS.Repo is where the repo commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @typep api_error :: MyspaceIPFS.ApiError.t()
  @typep opts :: MyspaceIPFS.opts()

  @doc """
  Perform a garbage collection sweep on the repo.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-repo-gc
    stream_errors - <bool>, # Stream errors during GC.
    quiet <bool>, # Write minimal output.
    silent <bool>, # Write no output.
  """
  @spec gc(opts) :: {:ok, any} | api_error()
  def gc(opts \\ []) do
    post_query("/repo/gc", query: opts)
    |> okify()
  end

  @doc """
  List all local repo blocks.
  """
  @spec ls :: {:ok, any} | api_error()
  def ls() do
    post_query("/repo/ls")
    |> okify()
  end

  @doc """
  Apply any outstanding repo migrations.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-repo-migrate
    allow-downgrade - <bool>, # Allow downgrading repo version.
  """
  @spec migrate(opts) :: {:ok, any} | api_error()
  def migrate(opts \\ []) do
    post_query("/repo/migrate", query: opts)
    |> okify()
  end

  @doc """
  Get stats for the currently used repo.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-repo-stat
    human - <bool>, # Output human-readable numbers.
    size-only - <bool>, # Only output the RepoSize.
  """
  @spec stat(opts) :: {:ok, any} | api_error()
  def stat(opts \\ []) do
    post_query("/repo/stat", query: opts)
    |> okify()
  end

  @doc """
  Verify all blocks in repo are not corrupted.
  """
  @spec verify :: {:ok, any} | api_error()
  def verify do
    post_query("/repo/verify")
    |> okify()
  end

  @doc """
  Show repo version.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-repo-version
    quiet - <bool>, # Write minimal output.
  """
  @spec version(opts) :: {:ok, any} | api_error()
  def version(opts \\ []) do
    post_query("/repo/version", query: opts)
    |> okify()
  end
end
