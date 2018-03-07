defmodule Waverider.Math do
  @spec byte_chunk_size(%Waverider.File{}) :: integer
  def byte_chunk_size(struct),
    do: (struct.bits_per_sample / 8 * struct.num_channels) |> float_to_int

  @spec byte_length_per_channel(list, integer) :: integer
  def byte_length_per_channel(byte_list, num_channels),
    do: (Enum.count(byte_list) / num_channels) |> float_to_int

  @spec audio_length(%Waverider.File{}) :: float
  def audio_length(%Waverider.File{sub_chunk_2_size: sub_chunk_2_size, byte_rate: byte_rate}),
    do: sub_chunk_2_size / byte_rate

  @spec float_to_int(float) :: integer
  defp float_to_int(float), do: float |> Float.to_string() |> Integer.parse() |> elem(0)
end
