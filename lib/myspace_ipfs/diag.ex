defmodule MyspaceIPFS.Diag do
  @moduledoc """
  MyspaceIPFS.Diag is where the diag commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @typep api_error :: MyspaceIPFS.Api.api_error()

  @doc """
  List commands run by the daemon.
  """
  # FIXME: return a proper struct
  @spec cmds() :: {:ok, any} | api_error()
  def cmds() do
    post_query("/diag/cmds")
    |> okify()
  end

  @doc """
  Clear the command history.
  """
  # FIXME: verify return type
  @spec clear() :: {:ok, any} | api_error()
  def clear do
    post_query("/diag/cmds/clear")
    |> okify()
  end

  @doc """
  Set retention time for command history.

  ## Parameters
  time: The time to set the retention time to.
  """
  # FIXME: return a proper struct
  @spec set_time(String.t()) :: {:ok, any} | api_error()
  def set_time(time) do
    post_query("/diag/cmds/set-time?arg=" <> time)
    |> okify()
  end

  @doc """
  Print system diagnostic information.
  """
  # FIXME: verify return type
  @spec sys() :: {:ok, any} | api_error()
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
  # FIXME: verify return value
  @spec profile(list) :: {:ok, any} | api_error()
  def profile(options \\ []) do
    MyspaceIPFS.Diag.Profile.start_link(options)
    |> okify()
  end
end
