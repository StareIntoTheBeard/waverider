defmodule Waverider.MathTest do
  use ExUnit.Case
  doctest Waverider.Math

  setup do
    struct_stub = %Waverider.File{
      bits_per_sample: 16,
      byte_rate: 32000,
      num_channels: 2,
      sub_chunk_2_size: 536_320
    }

    {:ok, %{struct_stub: struct_stub}}
  end

  test "byte_chunk_size/1 returns an int of the size of bytes per chunk", %{
    struct_stub: struct_stub
  } do
    assert Waverider.Math.byte_chunk_size(struct_stub) == 4
  end

  test "byte_length_per_channel/2 returns an int of the size of bytes per channel per chunk" do
    assert Waverider.Math.byte_length_per_channel([1, 2, 3, 4], 2) == 2
  end

  test "audio_length/1 returns number of audio seconds length of a file as float", %{
    struct_stub: struct_stub
  } do
    assert Waverider.Math.audio_length(struct_stub) == 16.76
  end
end
