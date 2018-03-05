defprotocol Wave do
  def parse(data)
end

defimpl Wave, for: BitString do
  import Waverider.Patterns
  @type wave_binary :: Waverider.Patterns.from_binary()
  @spec parse(wave_binary) :: %Waverider.File{}

  def parse(from_binary()) do
    %Waverider.File{
      chunk_id: chunk_id,
      chunk_size: chunk_size,
      format: format,
      sub_chunk_1_id: sub_chunk_1_id,
      sub_chunk_1_size: sub_chunk_1_size,
      audio_format: audio_format,
      num_channels: num_channels,
      sample_rate: sample_rate,
      byte_rate: byte_rate,
      block_align: block_align,
      bits_per_sample: bits_per_sample,
      sub_chunk_2_id: sub_chunk_2_id,
      sub_chunk_2_size: sub_chunk_2_size,
      data: data
    }
  end
end

defimpl Wave, for: Waverider.File do
  import Waverider.Patterns
  @type wave_binary :: Waverider.Patterns.from_binary()
  @spec parse(%Waverider.File{}) :: wave_binary

  def parse(data), do: to_binary(data)
end
