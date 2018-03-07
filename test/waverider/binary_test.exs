defmodule Waverider.BinaryTest do
  @pattern quote do: <<header::binary-size(44), var!(data)::binary>>
  use ExUnit.Case
  doctest Waverider.Binary

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

  test "chunk_data/1 chunks data into lists", %{struct_stub: struct_stub} do
    chunked_data = struct_stub |> Waverider.Binary.chunk_data()
    assert is_list(chunked_data)
    assert chunked_data |> Enum.count() == 134_080
    assert chunked_data |> List.first() |> is_list
    assert chunked_data |> List.first() |> Enum.count() == 4
  end

  test "from_list/1 takes a list of bytes and returns a bitstring" do
    assert [00, 01, 02, 03] |> Waverider.Binary.from_list() == <<00, 01, 02, 03>>
  end
end
