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
    case cid do
      %{"/" => something} ->
        %__MODULE__{/: something}

      _ ->
        %__MODULE__{/: cid}
    end
  end
end

defmodule MyspaceIPFS.Hash do
  @moduledoc """
  This struct is very simple. Some results are listed as "Hash": hash. This is a
  convenience struct to make it easier match on the result.
  """
  @enforce_keys [:hash, :name, :size, :type]
  defstruct hash: nil, name: nil, size: nil, target: "", type: nil

  @type t :: %__MODULE__{
          hash: binary,
          name: binary,
          size: non_neg_integer,
          target: binary,
          type: non_neg_integer()
        }

  @spec new(map) :: MyspaceIPFS.Hash.t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      hash: opts["Hash"],
      name: opts["Name"],
      size: opts["Size"],
      target: opts["Target"],
      type: opts["Type"]
    }
  end

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
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

defmodule MyspaceIPFS.Objects do
  @moduledoc """
  This struct is very simple. Some results are listed as "Hash": hash, "Links": links. This is a
  convenience struct to make it easier match on the result.
  """

  defstruct objects: []

  @type t :: %__MODULE__{objects: list}

  @spec new(map) :: MyspaceIPFS.Objects.t()
  def new(opts) when is_map(opts) do
    objects =
      opts["Objects"]
      |> Enum.map(&MyspaceIPFS.HashLinks.new/1)

    %__MODULE__{
      objects: objects
    }
  end

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end

defmodule MyspaceIPFS.HashLinks do
  @moduledoc """
  This struct is very simple. Some results are listed as "Hash": hash, "Links": links. This is a
  convenience struct to make it easier match on the result.
  """

  defstruct hash: nil, links: []

  @type t :: %__MODULE__{hash: binary, links: list}

  @spec new(map) :: MyspaceIPFS.HashLinks.t()
  def new(opts) when is_map(opts) do
    with links <- opts["Links"] |> Enum.map(&MyspaceIPFS.Hash.new/1),
         do: %__MODULE__{
           hash: opts["Hash"],
           links: links
         }
  end

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
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

defmodule MyspaceIPFS.Peers do
  @moduledoc """
  A struct that represents the wantlist for a peer in the bitswap network.
  """
  defstruct peers: []

  @type t :: %__MODULE__{
          peers: list | nil
        }
  @spec new(map) :: t()
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
