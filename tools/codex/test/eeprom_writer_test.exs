defmodule Codex.EEPROMWriterTest do
  use ExUnit.Case

  test "can connect to a firmata board" do
    {:ok, pid} =
      Codex.EEPROMWriter.start_link("COM6")
      |> Codex.EEPROMWriter.init_i2c(pid)
      |> Codex.EEPROMWriter.init_pins(pid)

    Codex.EEPROMWriter.write_byte(pid, <<0x2F>>, <<23>>)
  end
end
