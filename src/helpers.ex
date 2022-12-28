defmodule Helpers do
  def to_string(bitstring) do
    List.to_string(:binary.bin_to_list(bitstring))
  end
end
