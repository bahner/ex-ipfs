defmodule MyspaceIpfs.Diag do
  @moduledoc """
  MyspaceIpfs.Diag is where the diag commands of the IPFS API reside.
  """
  import MyspaceIpfs.Api
  import MyspaceIpfs.Utils

  @typep okresult :: MyspaceIpfs.okresult()

  @doc """
  List commands run by the daemon.
  """
  @spec cmds() :: okresult
  def cmds() do
    post_query("/diag/cmds")
    |> okify()
  end

  @doc """
  Clear the command history.
  """
  @spec clear() :: okresult
  def clear do
    post_query("/diag/cmds/clear")
    |> okify()
  end

  @doc """
  Set retention time for command history.

  ## Parameters
  time: The time to set the retention time to.
  """
  @spec set_time(String.t()) :: okresult
  def set_time(time) do
    post_query("/diag/cmds/set-time?arg=" <> time)
    |> okify()
  end

  @doc """
  Print system diagnostic information.
  """
  @spec sys() :: okresult
  def sys do
    post_query("/diag/sys")
    |> okify()
  end

  @doc """
  Collect a performance profile for debugging.

  NB! The recv_timeout is set to 35s. This is because the profile can take a
  while to generate. If you are getting a timeout error, try decreasing the
  profile-time. The default is 30s.

  ## Parameters
  timeout: The timeout for the request. Default is 35_000 milliseonds.
           This should be set to the profile-time + 5_000 milliseconds.
  output: The output file for the profile. Default is "ipfs-profile-#{timestamp()}.zip".
  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-diag-profile
  ```
  [
    "output": <string>, # Output file for the profile. Default: "ipfs-profile-#{timestamp()}.zip".
    "collectors": <array>, # List of collectors to use.
    "profile-time": <string>, # Time to run the profiler for.
    "mutex-profile-fraction": <number>, # Fraction of mutex contention events to profile.
    "block-profile-rate": <number>, # Rate to sample goroutine blocking events.
  ]
  ```
  """
  @spec profile(list) :: okresult
  def profile(options \\ []) do
    MyspaceIpfs.Diag.Profile.start_link(options)
    |> okify()
  end
end
