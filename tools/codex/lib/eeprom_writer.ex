defmodule Codex.EEPROMWriter do
  use Firmata.Protocol.Mixin
  use GenServer
  use Bitwise
  require Logger

  @i2c_expander 32
  @byte_pins [14, 15, 16, 17, 20, 21, 22, 23]

  defmodule State do
    defstruct firmata: nil
  end

  def start_link(port) do
    GenServer.start_link(__MODULE__, port, name: __MODULE__)
  end

  def init(port) do
    Logger.info("Connecting to Firmata on port: #{inspect(port)}")
    {:ok, firmata} = Firmata.Board.start_link(port, [], :hardware_interface)

    Logger.info("Initializing Firmata: #{inspect(firmata)}")
    Firmata.Board.sysex_write(firmata, @firmware_query, <<>>)

    {:ok, %State{firmata: firmata}}
  end

  def handle_info({:firmata, info}, state) do
    IO.inspect(info)
    {:noreply, state}
  end


  def handle_cast(:init_i2c, state) do
    init_i2c()
  end

  defp init_i2c() do
    IO.inspect state.firmata
    Firmata.Board.sysex_write(state.firmata, @i2c_config, <<>>)
    Process.send_after(self(), :read_i2c, 0)
    state
  end

  def init_pins(state) do
    Enum.each(@byte_pins, fn n ->
      Firmata.Board.set_pin_mode(state.firmata, n, @output)
    end)

    state
  end

  def write_byte(state, <<_address::binary>>, <<byte::size(8)>>) do
    Enum.each(byte_digits(byte), fn x ->
      {val, pin} = x
      Firmata.Board.digital_write(state.firmata, pin, val)
    end)
  end

  defp byte_digits(byte) do
    digits = Integer.digits(byte, 2)
    # Pad with 0s to get a full byte
    [List.duplicate(0, 8 - Enum.count(digits)) | digits]
    |> List.flatten()
    |> Enum.reverse()
    |> Enum.zip(@byte_pins)
  end
end
