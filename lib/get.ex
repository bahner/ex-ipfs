defmodule MyspaceIPFS.Get do
  @moduledoc false
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils
  require Logger

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

  @spec extract_elem_from_tar_to(fspath, fspath, fspath, fspath) :: :ok | {:error, any}
  def extract_elem_from_tar_to(file, elem, output, parent_tmp_dir \\ "/tmp") do
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
