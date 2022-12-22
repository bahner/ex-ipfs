defmodule MyspaceIPFS.Get do
  @moduledoc false
  import MyspaceIPFS.Api

  @typep path :: MyspaceIPFS.path()
  @typep fspath :: MyspaceIPFS.fspath()
  @typep opts :: MyspaceIPFS.opts()

  # FIXME: This is a hack to get around the fact that the IPFS API returns a tarball
  #       of the file(s). This should be fixed in the API.
  @spec get(path, opts) :: {:ok, fspath} | {:error, any}
  def get(path, opts \\ []) do
    with data <- post_query("/get?arg=" <> path, opts),
         name <- Path.basename(path),
         output <- Keyword.get(opts, :output, name),
         archive <- Keyword.get(opts, :archive, false),
         tmp <- write_tmpfile(data) do
      if archive do
        File.rename!(tmp, output)
        {:ok}
      else
        extract_elem_from_tar_to(tmp, name, output)
        File.rm_rf!(tmp)
        {:ok}
      end
    end
  end

  defp extract_elem_from_tar_to(file, elem, output) do
    with cwd <- mktempdir("/tmp") do
      case :erl_tar.extract(file, cwd: cwd) do
        :ok ->
          File.rename!("#{cwd}/#{elem}", output)

        {:error, {msg, err}} ->
          raise "Error extracting #{file}: #{msg} #{err}"
      end

      File.rm_rf!(cwd)
    end
  end

  defp write_tmpfile(data, dir \\ "/tmp") do
    with dir <- mktempdir(dir),
         name <- Nanoid.generate(),
         file <- dir <> "/" <> name do
      File.write!(file, data)
      file
    end
  end

  defp mktempdir(parent_dir) do
    with dir <- Nanoid.generate(),
         dir_path <- parent_dir <> "/" <> dir do
      File.mkdir_p(dir_path)
      dir_path
    end
  end
end
