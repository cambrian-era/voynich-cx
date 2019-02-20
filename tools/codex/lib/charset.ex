defmodule Codex.Charset do
  use Bitwise
  defstruct palette: nil, chars: nil

  @doc """
  Loads the charset from a .TGA file.

  """
  def load(path) do
    {result, data} = File.read(path)

    case result do
      :ok ->
        header = get_header(data)

        if Map.get(header, :color_map_type) == :hasmap do
          colormap = get_color_map(data, header)
          chars = get_chars(data, header)

          {:ok, %Codex.Charset{palette: colormap, chars: chars}}
        end

      :error ->
        IO.warn(data)
        {:error, data}
    end
  end

  def get_header(data) do
    <<id_length::integer-size(8)>> = Kernel.binary_part(data, 0, 1)

    get_color_map_type = fn data ->
      case Kernel.binary_part(data, 1, 1) do
        <<0>> ->
          :nomap

        <<1>> ->
          :hasmap

        _ ->
          :othermap
      end
    end

    get_image_type = fn data ->
      <<value::integer-size(8)>> = Kernel.binary_part(data, 2, 1)

      img_type =
        case value &&& 0b00000111 do
          0 ->
            :none

          1 ->
            :colormap

          2 ->
            :truecolor

          3 ->
            :grayscale
        end

      %{type: img_type, rle: value &&& 0b00001}
    end

    get_color_map_spec = fn data ->
      <<index::little-integer-size(16), length::little-integer-size(16),
        size::little-integer-size(8)>> = Kernel.binary_part(data, 3, 5)

      %{index: index, length: length, size: size}
    end

    get_image_spec = fn data ->
      <<
        x_origin::little-integer-size(16),
        y_origin::little-integer-size(16),
        width::little-integer-size(16),
        height::little-integer-size(16),
        bpp::little-integer-size(8),
        alpha_depth::little-integer-size(4),
        direction::little-integer-size(2),
        _::size(2)
      >> = Kernel.binary_part(data, 8, 10)

      %{
        x_origin: x_origin,
        y_origin: y_origin,
        width: width,
        height: height,
        bpp: bpp,
        alpha_depth: alpha_depth,
        direction: direction
      }
    end

    %{
      id_length: id_length,
      color_map_type: get_color_map_type.(data),
      image_type: get_image_type.(data),
      map_spec: get_color_map_spec.(data),
      image_spec: get_image_spec.(data)
    }
  end

  def get_color_map(
        data,
        %{
          :id_length => id_length,
          :map_spec => %{
            :length => length,
            :size => size
          }
        }
      ) do
    bytes = Integer.floor_div(size, 8)

    Kernel.binary_part(data, 18 + id_length, length * bytes)
    |> :binary.bin_to_list()
    |> Enum.chunk_every(bytes)
    |> Enum.take(16)
  end

  def get_chars(data, %{
        :id_length => id_length,
        :map_spec => %{:length => map_length, :size => map_size},
        :image_spec => %{
          :height => _height,
          :width => width
        }
      }) do
    image_start = 18 + id_length + map_length * Integer.floor_div(map_size, 8)

    bits =
      Kernel.binary_part(data, image_start, byte_size(data) - image_start)
      |> :binary.bin_to_list()
      |> parse_rle([])

    get_char = fn bits, codepoint ->
      Enum.map(0..7, fn n ->
        y = Integer.floor_div(codepoint, 16)
        x = Integer.mod(codepoint, 16)

        Enum.slice(bits, width * y * 8 + width * n + x * 8, 8)
        |> Enum.into(<<>>, fn bit -> <<bit::1>> end)
      end)
      |> Enum.into(<<>>, fn byte -> byte end)
    end

    Enum.map(0..255, fn n ->
      get_char.(bits, n)
    end)
  end

  defp parse_rle([head | data], acc) do
    {values, remaining} =
      case <<head>> do
        <<1::size(1), run::bitstring>> ->
          <<len::integer-size(8)>> = <<0::1, run::bitstring>>
          [val | tail] = data
          {Enum.map(0..len, fn _ -> val end), tail}

        <<0::size(1), run::bitstring>> ->
          <<len::integer-size(8)>> = <<0::1, run::bitstring>>
          Enum.split(data, len + 1)
      end

    bits = Enum.concat(acc, values)

    if remaining == [] do
      bits
    else
      parse_rle(remaining, bits)
    end
  end
end
