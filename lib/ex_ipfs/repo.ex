defmodule ExIPFS.Repo do
  @moduledoc """
  ExIPFS.Repo is where the repo commands of the IPFS API reside.
  """
  import ExIPFS.Api
  import ExIPFS.Utils

  @doc """
  Perform a garbage collection sweep on the repo.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-repo-gc
    stream_errors - <bool>, # Stream errors during GC.
    quiet <bool>, # Write minimal output.
    silent <bool>, # Write no output.
  """
  @spec gc(list()) :: {:ok, any} | ExIPFS.Api.error_response()
  def gc(opts \\ []) do
    post_query("/repo/gc", query: opts)
    |> okify()
  end

  @doc """
  List all local repo blocks.
  """
  @spec ls :: {:ok, any} | ExIPFS.Api.error_response()
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
  @spec migrate(list()) :: {:ok, any} | ExIPFS.Api.error_response()
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
  @spec stat(list()) :: {:ok, any} | ExIPFS.Api.error_response()
  def stat(opts \\ []) do
    post_query("/repo/stat", query: opts)
    |> okify()
  end

  @doc """
  Verify all blocks in repo are not corrupted.
  """
  @spec verify :: {:ok, any} | ExIPFS.Api.error_response()
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
  @spec version(list()) :: {:ok, any} | ExIPFS.Api.error_response()
  def version(opts \\ []) do
    post_query("/repo/version", query: opts)
    |> okify()
  end
end
