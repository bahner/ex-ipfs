defmodule MyspaceIpfs.RootCid do
  @moduledoc """
  This struct is very simple. Some results are listed as `%{"/": cid}`. This is a
  convenience struct to make it easier match on the result.

  The name is odd, but it signifies that it is a CID of in the API notation, with the
  leading slash.
  """

  @typep cid :: MyspaceIpfs.cid()
  # The CID of the root object.
  defstruct /: nil

  @type t :: %__MODULE__{/: cid}
end

defmodule MyspaceIpfs.KeySize do
  @moduledoc """
  This struct is very simple. Some results are listed as "Size": size. This is a
  convenience struct to make it easier match on the result.
  """

  defstruct key: nil, size: nil

  @type t :: %__MODULE__{key: binary, size: non_neg_integer}
end

defmodule MyspaceIpfs.KeyValue do
  @moduledoc """
  This struct is very simple. Some results are listed as "Value": size. This is a
  convenience struct to make it easier match on the result.
  """

  defstruct key: nil, value: nil

  @type t :: %__MODULE__{key: binary, value: binary}
end

defmodule MyspaceIpfs.Hash do
  @moduledoc """
  This struct is very simple. Some results are listed as "Size": size. This is a
  convenience struct to make it easier match on the result.
  """

  defstruct hash: nil

  @type t :: %__MODULE__{hash: MyspaceIpfs.cid()}
end

defmodule MyspaceIpfs.ErrorHash do
  @moduledoc """
  This struct is very simple. Some results are listed as "Error": error, "Hash": hash. This is a
  """

  defstruct error: nil, hash: nil

  @type t :: %__MODULE__{error: binary, hash: binary}
end

defmodule MyspaceIpfs.Add do
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
end
