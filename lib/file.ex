defmodule Waverider.File do
  import Waverider.Pattern

  defstruct [
    :chunk_id,
    :chunk_size,
    :format,
    :sub_chunk_1_id,
    :sub_chunk_1_size,
    :audio_format,
    :num_channels,
    :sample_rate,
    :byte_rate,
    :block_align,
    :bits_per_sample,
    :sub_chunk_2_id,
    :sub_chunk_2_size,
    :data
  ]

  @spec construct(binary(), map) :: %__MODULE__{}
  def construct(pattern(), attrs \\ %{}) do
    %__MODULE__{
      chunk_id: Map.get(attrs, :chunk_id) || chunk_id,
      chunk_size: Map.get(attrs, :chunk_size) || chunk_size,
      format: Map.get(attrs, :format) || format,
      sub_chunk_1_id: Map.get(attrs, :sub_chunk_1_id) || sub_chunk_1_id,
      sub_chunk_1_size: Map.get(attrs, :sub_chunk_1_size) || sub_chunk_1_size,
      audio_format: Map.get(attrs, :audio_format) || audio_format,
      num_channels: Map.get(attrs, :num_channels) || num_channels,
      sample_rate: Map.get(attrs, :sample_rate) || sample_rate,
      byte_rate: Map.get(attrs, :byte_rate) || byte_rate,
      block_align: Map.get(attrs, :block_align) || block_align,
      bits_per_sample: Map.get(attrs, :bits_per_sample) || bits_per_sample,
      sub_chunk_2_id: Map.get(attrs, :sub_chunk_2_id) || sub_chunk_2_id,
      sub_chunk_2_size: Map.get(attrs, :sub_chunk_2_size) || sub_chunk_2_size,
      data: Map.get(attrs, :data) || data
    }
  end

  @spec read(binary()) :: {:ok, %__MODULE__{}}
  def read(file_path) do
    {:ok, binary} = File.read(file_path)
    {:ok, _struct} = parse(binary)
  end

  @spec parse(binary()) :: {:ok, %__MODULE__{}}
  def parse(pattern()) do
    {:ok, __MODULE__.construct(pattern())}
  end

  @spec write(%__MODULE__{}, binary()) :: :ok
  def write(struct, path) do
    File.write(path, pattern(struct), [])
  end
end
