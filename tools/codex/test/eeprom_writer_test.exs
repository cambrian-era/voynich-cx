defmodule Codex.EEPROMWriterTest do
  use ExUnit.Case

  test "can connect to a firmata board" do
    {:ok, state} = Codex.EEPROMWriter.start_link("COM6")

    IO.inspect state.firmata
    Codex.EEPROMWriter.init_i2c()

    # Codex.EEPROMWriter.init_pins(state)

    # Codex.EEPROMWriter.write_byte(state, <<0x2F>>, <<23>>)
  end
end
