defmodule Waverider.File do
  defmodule TypeError do
    defexception [:message]
  end

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

  @spec read(String.t()) :: %__MODULE__{}
  def read(file_path) do
    case String.ends_with?(file_path, ".wav") do
      true ->
      %Waverider.File{} =
        File.read!(file_path)
        |> Wave.parse()
      false -> raise(Waverider.File.TypeError, [message: "must be a wave file."])
    end
  end

  @spec write(%__MODULE__{}, String.t()) :: :ok
  def write(struct, path) do
    path
    |> File.write(Wave.parse(struct), [])
  end
end
