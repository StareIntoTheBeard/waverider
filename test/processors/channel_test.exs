defmodule Waverider.Processor.ChannelTest do
  @pattern quote do: <<header::binary-size(44), var!(data)::binary>>
  use ExUnit.Case
  doctest Waverider.Processor.Channel

  setup do
    {:ok, binary} = File.read("#{File.cwd!()}/test/stereo_stub.wav")
    unquote(@pattern) = binary

    struct_stub = %Waverider.File{
      audio_format: 1,
      bits_per_sample: 16,
      block_align: 4,
      byte_rate: 32000,
      chunk_id: "RIFF",
      chunk_size: 536_356,
      data: data,
      format: "WAVE",
      num_channels: 2,
      sample_rate: 8000,
      sub_chunk_1_id: "fmt ",
      sub_chunk_1_size: 16,
      sub_chunk_2_id: "data",
      sub_chunk_2_size: 536_320
    }

    {:ok, %{struct_stub: struct_stub}}
  end

  test ".split_stereo/1 returns two mono file structs from a stereo file struct", %{
    struct_stub: struct_stub
  } do
    {:ok, file_one, file_two} = Waverider.Processor.Channel.split_stereo(struct_stub)

    assert file_one.__struct__ == Waverider.File
    assert file_one.num_channels == 1
    assert file_one.data |> byte_size == (struct_stub.data |> byte_size) / 2
    assert file_two.__struct__ == Waverider.File
    assert file_two.num_channels == 1
    assert file_two.data |> byte_size == (struct_stub.data |> byte_size) / 2
  end
end
