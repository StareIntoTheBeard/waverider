defmodule Waverider.Processor.Channel do
  @spec split_stereo(%Waverider.File{}) :: {:ok, [[any()] | byte()], [[any()] | byte()]}
  def split_stereo(struct) do
    struct
    |> handle_binary()
  end

  @spec handle_binary(%Waverider.File{}) :: {:ok, [[any()] | byte()], [[any()] | byte()]}
  defp handle_binary(struct) do
    struct
    |> Map.get(:data)
    |> :binary.bin_to_list()
    |> split_stereo(struct)
  end

  @spec split_stereo(list, list, list, map) :: {:ok, [binary()], [binary()]}
  defp split_stereo(list, channel_one \\ [], channel_two \\ [], struct)

  defp split_stereo(
         [byte_one, byte_two, byte_three, byte_four | tail],
         channel_one,
         channel_two,
         struct
       ) do
    channel_one = [channel_one | [byte_one, byte_two]]
    channel_two = [channel_two | [byte_three, byte_four]]
    split_stereo(tail, channel_one, channel_two, struct)
  end

  defp split_stereo([], channel_one, channel_two, struct) do
    [first_channel | [second_channel]] =
      Enum.map(
        [channel_one, channel_two],
        &Map.merge(struct, %{data: return_binary_data_from_list(&1), num_channels: 1})
      )

    {:ok, first_channel, second_channel}
  end

  @spec return_binary_data_from_list(list) :: binary()
  defp return_binary_data_from_list(data) when is_list(data) do
    data |> :binary.list_to_bin()
  end
end
