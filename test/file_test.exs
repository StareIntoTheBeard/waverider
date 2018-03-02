defmodule Waverider.FileTest do
  @pattern quote do: <<header::binary-size(44), var!(data)::binary>>
  use ExUnit.Case
  doctest Waverider.File

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

    {:ok, %{binary: binary, struct_stub: struct_stub}}
  end

  test ".construct/1 builds a File struct", %{binary: binary, struct_stub: struct_stub} do
    assert Waverider.File.construct(binary) == struct_stub
  end

  test ".construct/2 builds a File struct and updates attributes set in map", %{
    binary: binary,
    struct_stub: struct_stub
  } do
    assert Waverider.File.construct(binary, %{num_channels: 12}) ==
             struct_stub |> Map.put(:num_channels, 12)
  end

  test ".read/1 reads a binary and returns {:ok, file_struct}", %{struct_stub: struct_stub} do
    assert Waverider.File.read("#{File.cwd!()}/test/stereo_stub.wav") == {:ok, struct_stub}
  end

  test ".parse/1 returns a File struct", %{binary: binary, struct_stub: struct_stub} do
    assert Waverider.File.parse(binary) == {:ok, struct_stub}
  end

  test ".write/2 writes a file struct to disk as binary data", %{
    binary: binary,
    struct_stub: struct_stub
  } do
    assert :ok == Waverider.File.write(struct_stub, "#{File.cwd!()}/test/test_output.wav")
    {:ok, binary_verification} = File.read("#{File.cwd!()}/test/test_output.wav")
    assert binary_verification == binary
    File.rm("#{File.cwd!()}/test/test_output.wav")
  end
end
