defmodule Waverider.Pattern do
  defmacro pattern(struct) do
    quote do
      <<
        Map.get(unquote(struct), :chunk_id)::binary-size(4),
        Map.get(unquote(struct), :chunk_size)::little-unsigned-integer-size(32),
        Map.get(unquote(struct), :format)::binary-size(4),
        Map.get(unquote(struct), :sub_chunk_1_id)::binary-size(4),
        Map.get(unquote(struct), :sub_chunk_1_size)::little-unsigned-integer-size(32),
        Map.get(unquote(struct), :audio_format)::little-unsigned-integer-size(16),
        Map.get(unquote(struct), :num_channels)::little-unsigned-integer-size(16),
        Map.get(unquote(struct), :sample_rate)::little-unsigned-integer-size(32),
        Map.get(unquote(struct), :byte_rate)::little-unsigned-integer-size(32),
        Map.get(unquote(struct), :block_align)::little-unsigned-integer-size(16),
        Map.get(unquote(struct), :bits_per_sample)::little-unsigned-integer-size(16),
        Map.get(unquote(struct), :sub_chunk_2_id)::binary-size(4),
        Map.get(unquote(struct), :sub_chunk_2_size)::little-unsigned-integer-size(32),
        Map.get(unquote(struct), :data)::binary
      >>
    end
  end

  defmacro pattern() do
    quote do
      <<var!(chunk_id)::binary-size(4),
        var!(chunk_size)::little-unsigned-integer-size(32),
        var!(format)::binary-size(4),
        var!(sub_chunk_1_id)::binary-size(4),
        var!(sub_chunk_1_size)::little-unsigned-integer-size(32),
        var!(audio_format)::little-unsigned-integer-size(16),
        var!(num_channels) ::little-unsigned-integer-size(16),
        var!(sample_rate)::little-unsigned-integer-size(32),
        var!(byte_rate)::little-unsigned-integer-size(32),
        var!(block_align)::little-unsigned-integer-size(16),
        var!(bits_per_sample)::little-unsigned-integer-size(16),
        var!(sub_chunk_2_id)::binary-size(4),
        var!(sub_chunk_2_size)::little-unsigned-integer-size(32),
        var!(data)::binary>>
    end
  end
end