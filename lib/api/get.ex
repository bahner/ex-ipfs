defmodule MyspaceIPFS.Api.Get do
  @moduledoc false
  import MyspaceIPFS

  @type result :: MyspaceIPFS.result()
  @type path :: MyspaceIPFS.path()
  @type opts :: MyspaceIPFS.opts()
  @type fspath :: MyspaceIPFS.fspath()
  @type name :: MyspaceIPFS.name()

  # TODO: add get for compress and compression level

  @spec get(path, opts) :: result
  def get(path, opts \\ []) do
    with data <- post_query("/get?arg=" <> path, opts),
         temp = write_to_temp_file(data),
         content_name <- get_content_name(temp),
         output <- Keyword.get(opts, :output, content_name),
         archive <- Keyword.get(opts, :archive, false) do
      if archive do
        File.rename!(temp, output)
        {:ok}
      else
        extract_tar_to_path(temp, output)
        File.rm_rf!(temp)
        {:ok}
      end
    end
  end

  defp extract_tar_to_path(filename, output) do
    with cwd <- mktempdir(),
         name <- get_content_name(filename) do
      :erl_tar.extract(filename, cwd: cwd)
      File.rename!("#{cwd}/#{name}", output)
      File.rm_rf!(cwd)
    end
  end

  defp write_to_temp_file(data) do
    with dir <- mktempdir(),
         name <- Nanoid.generate(),
         file <- dir <> "/" <> name do
      File.write!(file, data)
      file
    end
  end

  def get_content_name(tarball) do
    with {:ok, files} <- :erl_tar.table(tarball) do
      files
      |> List.first()
    end
  end

  defp mktempdir(parent_dir \\ "/tmp") do
    with dir <- Nanoid.generate(),
         dir_path <- parent_dir <> "/" <> dir do
      File.mkdir_p(dir_path)
      dir_path
    end
  end
end
