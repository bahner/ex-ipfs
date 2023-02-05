defmodule MyspaceIPFS.Diag do
  @moduledoc """
  MyspaceIPFS.Diag is where the diag commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @typedoc """
  A commands element from the Diag Cmds command.
  """
  @type cmd :: %MyspaceIPFS.DiagCmd{
          active: boolean(),
          args: list(),
          command: binary(),
          end_time: binary(),
          id: integer(),
          options: map(),
          start_time: binary()
        }

  @type profile :: %MyspaceIPFS.DiagProfile{
          output: Path.t(),
          timeout: binary,
          writer: pid,
          ref: reference,
          query_options: list
        }

  @doc """
  List commands run by the daemon. A history.
  """
  # FIXME: return a proper struct
  @spec cmds() :: {:ok, list} | MyspaceIPFS.Api.error_response()
  def cmds() do
    post_query("/diag/cmds")
    |> MyspaceIPFS.DiagCmd.new()
    |> okify()
  end

  @doc """
  Clear the command history.
  """
  # FIXME: verify return type
  @spec clear() :: {:ok, any} | MyspaceIPFS.Api.error_response()
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
  @spec set_time(binary()) :: {:ok, any} | MyspaceIPFS.Api.error_response()
  def set_time(time) do
    post_query("/diag/cmds/set-time?arg=" <> time)
    |> okify()
  end

  @doc """
  Print system diagnostic information.
  """
  # FIXME: verify return type
  @spec sys() :: {:ok, map} | MyspaceIPFS.Api.error_response()
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
  @spec profile(list) :: {:ok, any} | MyspaceIPFS.Api.error_response()
  def profile(options \\ []) do
    MyspaceIPFS.DiagProfile.start_link(options)
  end
end
