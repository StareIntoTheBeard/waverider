defmodule Waverider.Binary do
  @spec chunk_data(%Waverider.File{}) :: list
  def chunk_data(waverider_file_struct) when is_map(waverider_file_struct) do
    waverider_file_struct
    |> Map.get(:data)
    |> :binary.bin_to_list()
    |> Enum.chunk_every(Waverider.Math.byte_chunk_size(waverider_file_struct))
  end

  @spec from_list(list) :: binary()
  def from_list(byte_list) when is_list(byte_list) do
    byte_list |> :binary.list_to_bin()
  end
end
