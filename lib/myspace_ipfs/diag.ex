defmodule MyspaceIPFS.Diag do
  @moduledoc """
  MyspaceIPFS.Diag is where the diag commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @typep okresult :: MyspaceIPFS.okresult()
  @typep opts :: MyspaceIPFS.opts()

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
    |> handle_plain_response()
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

  NB! The recv_timeout is set to 35s. This is because the profile can take a
  while to generate. If you are getting a timeout error, try decreasing the
  profile-time. The default is 30s.

  ## Parameters
  timeout: The timeout for the request. Default is 35_000 milliseonds.
           This should be set to the profile-time + 5_000 milliseconds.
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
  @spec profile(integer, opts) :: any
  def profile(timeout \\ 35_000, opts \\ []) do
    with output <- Keyword.get(opts, :output, "ipfs-profile-#{timestamp()}.zip") do
      post_query("/diag/profile",
        opts: [adapter: [recv_timeout: timeout]],
        query: opts
      )
      |> handle_file_response(output)
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
