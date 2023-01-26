defmodule MyspaceIpfs.Get do
  @moduledoc false
  import MyspaceIpfs.Api
  import MyspaceIpfs.Utils
  require Logger

  @enforce_keys [:path, :fspath, :content]
  defstruct [:path, :fspath, :name, :content, archive: false]

  @typep path :: MyspaceIpfs.path()
  @typep fspath :: MyspaceIpfs.fspath()
  @typep opts :: MyspaceIpfs.opts()
  @typep tesla_error :: MyspaceIpfs.tesla_error()

  @typep t :: %__MODULE__{
           path: path,
           fspath: fspath,
           name: binary,
           content: binary,
           archive: boolean
         }

  # FIXME: This is a hack to get around the fact that the IPFS API returns a tarball
  #       of the file(s). This should be fixed in the API.
  # TODO: QA this module, because it's a bit of a mess at this point. But better than it was.
  @spec get(path, opts) :: {:ok, fspath} | tesla_error
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

  defp get_get_data(path, opts) do
    options = create_query_opts(opts)

    reply =
      post_query("/get?arg=" <> path, options)
      |> handle_api_response()

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
    %MyspaceIpfs.Get{
      path: path,
      fspath: Keyword.get(opts, :output, :filename.basename(path)),
      name: :filename.basename(path),
      content: content,
      archive: Keyword.get(opts, :archive, false)
    }
  end

  @spec handle_output(t) :: {:ok, fspath} | {:error, any}
  defp handle_output(get) do
    {:ok, tmp} = write_temp_file(get.content)

    if get.archive do
      File.rename!(tmp, get.fspath)
      {:ok, get.fspath}
    else
      extract_elem_from_tar_to(tmp, get.name, get.fspath)
      File.rm_rf!(tmp)
      {:ok, get.fspath}
    end
  end

  @spec extract_elem_from_tar_to(fspath, fspath, fspath, fspath) :: :ok | {:error, any}
  defp extract_elem_from_tar_to(file, elem, output, parent_tmp_dir \\ "/tmp") do
    with cwd when is_bitstring(cwd) <- mktempdir(parent_tmp_dir),
         extract_result <- :erl_tar.extract(file, [{:cwd, ~c'#{cwd}'}]) do
      if :ok == extract_result do
        File.rename!("#{cwd}/#{elem}", output)
        File.rm_rf!(cwd)
        :ok
      else
        File.rm_rf!(cwd)
        extract_result
      end
    end
  end
end
