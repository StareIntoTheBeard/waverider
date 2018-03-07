defmodule Waverider.Processor.Channel do
  defmodule MismatchError do
    defexception [:message]
  end

  @spec split_stereo(%Waverider.File{}) :: {:ok, %Waverider.File{}, %Waverider.File{}}
  def split_stereo(%Waverider.File{num_channels: 2} = struct) do
    struct
    |> Waverider.Binary.chunk_data()
    |> split_stereo(struct)
  end

  def split_stereo(%Waverider.File{}),
    do: raise(Waverider.Processor.Channel.MismatchError, message: "must be a stereo wav file")

  @spec split_stereo(list, list, list, map) :: {:ok, %Waverider.File{}, %Waverider.File{}}
  defp split_stereo(list, channel_one \\ [], channel_two \\ [], struct)

  defp split_stereo(
         [current_byte_set | tail],
         channel_one,
         channel_two,
         struct
       ) do
    {left_bytes, right_bytes} =
      current_byte_set
      |> Enum.split(Waverider.Math.byte_length_per_channel(current_byte_set, struct.num_channels))

    split_stereo(
      tail,
      [channel_one | left_bytes],
      [channel_two | right_bytes],
      struct
    )
  end

  defp split_stereo([], channel_one, channel_two, struct) do
    [first_channel | [second_channel]] =
      Enum.map(
        [channel_one, channel_two],
        &Map.merge(struct, %{data: Waverider.Binary.from_list(&1), num_channels: 1})
      )

    {:ok, first_channel, second_channel}
  end
end
