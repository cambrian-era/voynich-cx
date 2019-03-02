defmodule Codex.Hardware.MCP23017 do
  use Firmata.Protocol.Mixin

  @i2c_channel 0x20

  @ipdira 0x00
  @ipdirb 0x00

  @olata 0x14
  @olatb 0x15

  def set_mode(:output, firmata) do
    Firmata.Board.sysex_write(
      firmata,
      @i2c_request,
      <<@i2c_channel, @i2c_mode.write, @ipdira, 0>>
    )

    Firmata.Board.sysex_write(
      firmata,
      @i2c_request,
      <<@i2c_channel, @i2c_mode.write, @ipdirb, 0>>
    )
  end

  def set_address(address, firmata) when address > 0xFF and address <= 0xFFFF do
    Firmata.Board.sysex_write(
      firmata,
      @i2c_request,
      <<@i2c_channel, @i2c_mode.write, @olata, address >>> 8>>
    )

    Firmata.Board.sysex_write(
      firmata,
      @i2c_request,
      <<@i2c_channel, @i2c_mode.write, @olatb, address &&& 0xFF>>
    )
  end

  def set_address(address, firmata) when address <= 0xFF do
    Firmata.Board.sysex_write(
      firmata,
      @i2c_request,
      <<@i2c_channel, @i2c_mode.write, @olata, address>>
    )

    Firmata.Board.sysex_write(firmata, @i2c_request, <<@i2c_channel, @i2c_mode.write, @olatb, 0>>)
  end
end
