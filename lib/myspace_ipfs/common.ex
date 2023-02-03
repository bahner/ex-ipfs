defmodule MyspaceIPFS.RootCid do
  @moduledoc """
  This struct is very simple. Some results are listed as `%{"/": cid}`. This is a
  convenience struct to make it easier match on the result.

  The name is odd, but it signifies that it is a CID of in the API notation, with the
  leading slash.
  """

  @typep cid :: MyspaceIPFS.cid()
  # The CID of the root object.
  defstruct /: nil

  @type t :: %__MODULE__{/: cid}

  @spec new(any) :: MyspaceIPFS.RootCid.t()
  def new(cid) do
    IO.inspect(cid, label: "cid")

    case cid do
      %{"/" => something} ->
        %__MODULE__{/: something}

      _ ->
        %__MODULE__{/: cid}
    end
  end
end

defmodule MyspaceIPFS.KeySize do
  @moduledoc """
  This struct is very simple. Some results are listed as "Size": size. This is a
  convenience struct to make it easier match on the result.
  """

  defstruct key: nil, size: nil

  @type t :: %__MODULE__{key: binary, size: non_neg_integer}

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}

  @spec new(map) :: MyspaceIPFS.KeySize.t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      key: opts.key,
      size: opts.size
    }
  end
end

defmodule MyspaceIPFS.KeyValue do
  @moduledoc """
  This struct is very simple. Some results are listed as "Value": size. This is a
  convenience struct to make it easier match on the result.
  """

  defstruct key: nil, value: nil

  @type t :: %__MODULE__{key: binary, value: binary}

  @spec new(map) :: MyspaceIPFS.KeyValue.t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      key: opts.key,
      value: opts.value
    }
  end

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end

defmodule MyspaceIPFS.ErrorHash do
  @moduledoc """
  This struct is very simple. Some results are listed as "Error": error, "Hash": hash. This is a
  """

  defstruct error: "", hash: nil

  @type t :: %__MODULE__{error: binary, hash: binary}

  @spec new(map) :: MyspaceIPFS.ErrorHash.t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      error: Map.get(opts, :error, ""),
      hash: opts.hash
    }
  end

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end

defmodule MyspaceIPFS.Add do
  @moduledoc """
  This struct is very simple. Some results are listed as "Bytes": bytes, "Hash": hash, "Size": size, "Type": type. This is a
  convenience struct to make it easier match on the result.

  This is returned when you add a file or directory to IPFS.
  """
  defstruct bytes: nil, hash: nil, size: nil, type: nil

  @type t :: %__MODULE__{
          bytes: non_neg_integer,
          hash: binary,
          size: non_neg_integer,
          type: binary
        }

  @spec new(map) :: MyspaceIPFS.Add.t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      bytes: opts.bytes,
      hash: opts.hash,
      size: opts.size,
      type: opts.type
    }
  end

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end

defmodule MyspaceIPFS.Peers do
  @moduledoc """
  A struct that represents the wantlist for a peer in the bitswap network.
  """
  defstruct peers: []

  @type t :: %__MODULE__{
          peers: list | nil
        }
  @spec new(map) :: MyspaceIPFS.Peers.t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      peers: opts.peers
    }
  end

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end

defmodule MyspaceIPFS.Path do
  @moduledoc """
  A struct that a resolved IPFS/IPNS path.
  """
  defstruct path: nil

  @typep path :: MyspaceIPFS.path()

  @type t :: %__MODULE__{
          path: path | nil
        }

  @spec new(map) :: MyspaceIPFS.Path.t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      path: opts["Path"]
    }
  end

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
