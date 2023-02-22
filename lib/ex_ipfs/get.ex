defmodule ExIpfs.Get do
  @moduledoc """
  Get a file from IPFS and write it to a file or directory.
  """
  import ExIpfs.Api
  require Logger

  @enforce_keys [:path, :fspath, :content]
  defstruct [:path, :fspath, :name, :content, archive: false]

  @doc false
  @spec get(Path.t(), list) :: {:ok, Path.t()} | ExIpfs.Api.error_response()
  def get(path, opts \\ []) do
    content = get_get_data(path, opts)

    case content do
      {:error, reason} ->
        {:error, reason}

      _ ->
        create_output_struct(path, content, opts)
        |> handle_output()
    end
  end

  # @spec get_get_data(path, opts) :: {:ok, fspath} | ExIpfs.Api.error_response
  defp get_get_data(path, opts) do
    options = create_query_opts(opts)

    reply = post_query("/get?arg=" <> path, options)

    case reply do
      {:error, reason} ->
        Logger.error("Error getting data: #{inspect(reason)}")
        {:error, reason}

      _ ->
        reply
    end
  end

  defp create_query_opts(opts) do
    timeout = Keyword.get(opts, :timeout, 10_000)
    [opts: [adpapter: [:recv_timeout, timeout]]]
  end

  defp create_output_struct(path, content, opts) do
    # The default for output for fspath is the basename of the path
    # which is the IPFS CID.
    # We also store this to :name because we need to know it for extraction
    # from the tarball.
    %__MODULE__{
      path: path,
      fspath: Keyword.get(opts, :output, :filename.basename(path)),
      name: :filename.basename(path),
      content: content,
      archive: Keyword.get(opts, :archive, false)
    }
  end

  defp handle_output(get) do
    Temp.track!()

    {:ok, fd, tmp} = Temp.open("ex_handle_output")

    IO.binwrite(fd, get.content)

    if get.archive do
      File.rename!(tmp, get.fspath)
      {:ok, get.fspath}
    else
      extract_elem_from_tar_to(tmp, get.name, get.fspath)
      {:ok, get.fspath}
    end
  end

  defp extract_elem_from_tar_to(file, elem, output, parent_tmp_dir \\ "/tmp") do
    Temp.track!()

    with cwd when is_bitstring(cwd) <- Temp.path!(parent_tmp_dir),
         extract_result <- :erl_tar.extract(file, [{:cwd, ~c'#{cwd}'}]) do
      if :ok == extract_result do
        File.rename!("#{cwd}/#{elem}", output)
        :ok
      end
    end
  end
end
