defmodule MyspaceIPFS.Diag do
  @moduledoc """
  MyspaceIPFS.Diag is where the diag commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @typep okresult :: MyspaceIPFS.okresult()

  @doc """
  List commands run by the daemon.
  """
  @spec cmds() :: okresult
  def cmds() do
    post_query("/diag/cmds")
    |> handle_json_response()
  end

  @doc """
  Clear the command history.
  """
  @spec clear() :: okresult
  def clear do
    post_query("/diag/cmds/clear")
    |> handle_data_response()
  end

  @doc """
  Set retention time for command history.

  ## Parameters
  time: The time to set the retention time to.
  """
  @spec set_time(String.t()) :: okresult
  def set_time(time) do
    post_query("/diag/cmds/set-time?arg=" <> time)
    |> handle_json_response()
  end

  @doc """
  Collect a performance profile for debugging.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-diag-profile
  ```
  [
    "output": <string>, # Output file for the profile.
    "collectors": <array>, # List of collectors to use.
    "profile-time": <string>, # Time to run the profiler for.
    "mutex-profile-fraction": <number>, # Fraction of mutex contention events to profile.
    "block-profile-rate": <number>, # Rate to sample goroutine blocking events.
  ]
  ```
  """
  def profile(opts \\ []) do
    with output <- Keyword.get(opts, :output, "ipfs-profile-#{timestamp()}.zip") do
      IO.puts("Getting profile...")
      post_query("/diag/profile", query: opts)
      |> handle_file_response(output)
      IO.puts("Profile written to #{output}")
    end
  end

  @doc """
  Print system diagnostic information.
  """
  @spec sys() :: okresult
  def sys do
    post_query("/diag/sys")
    |> handle_json_response()
  end
end
