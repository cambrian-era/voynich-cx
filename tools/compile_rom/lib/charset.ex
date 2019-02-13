defmodule CompileRom.Charset do
  use Bitwise
  defstruct palette: nil, chars: nil
  
  def load(path) do
    { result, data } = File.read(path)

    case result do
      :ok ->
        header = get_header(data)
        if Map.get(header, :color_map_type) == :hasmap do
          colormap = get_color_map(data, header)
          chars = get_chars(data, header)
        end
      :error ->
        IO.warn(data)
    end
  end

  def get_header(data) do
    << id_length :: integer-size(8) >> = Kernel.binary_part(data, 0, 1)

    get_color_map_type = fn (data) ->
      case Kernel.binary_part(data, 1, 1) do
        <<0>> ->
          :nomap
        <<1>> ->
          :hasmap
        _ ->
          :othermap
      end
    end

    get_image_type = fn (data) ->
      << value :: integer-size(8) >> = Kernel.binary_part(data, 2, 1)

      img_type = case value &&& 0b00000111 do
        0 ->
          :none
        1 ->
          :colormap
        2 ->
          :truecolor
        3 ->
          :grayscale
      end

      %{ type: img_type, rle: value &&& 0b00001 }
    end

    get_color_map_spec = fn (data) ->
      <<
        index :: little-integer-size(16),
        length :: little-integer-size(16),
        size :: little-integer-size(8)>> = Kernel.binary_part(data, 3, 5)
      
      %{ index: index, length: length, size: size }
    end

    get_image_spec = fn (data) ->
      <<
        x_origin :: little-integer-size(16),
        y_origin :: little-integer-size(16), 
        width :: little-integer-size(16),
        height :: little-integer-size(16),
        bpp :: little-integer-size(8),
        alpha_depth :: little-integer-size(4),
        direction :: little-integer-size(2),
        _ :: size(2)
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

  def get_color_map(data, 
      %{
        :id_length => id_length, 
        :map_spec => %{ 
          :index => index, 
          :length => length,
          :size => size 
      } }) do
    bytes = Integer.floor_div( size, 8 )
    Kernel.binary_part(data, 18 + id_length, length * bytes ) |>
    :binary.bin_to_list() |>
    Enum.chunk_every(bytes) |>
    Enum.take(16)
  end

  def get_chars(data, %{
      :id_length => id_length,
      :map_spec => %{ :length => map_length, :size => map_size },
      :image_spec => %{
        :bpp => bpp,
        :height => height,
        :width => width
      } }) do
    image_start = 18 + id_length + ( map_length * Integer.floor_div( map_size, 8 ) )
    image_length = (Integer.floor_div( bpp, 8 ) * height * width)
    bits = Kernel.binary_part(data, image_start, byte_size(data) - (image_start + 1)) |>
    :binary.bin_to_list() |>
    Enum.chunk_every(2) |>
    Enum.map(fn ([len, val]) ->
      Enum.map([0..len], fn n -> val end)
    end) |> List.flatten()

    get_char = fn (x, y, width, height) ->
      Enum.map([0..8], fn n -> 
        
      end) 
    end
  end
end