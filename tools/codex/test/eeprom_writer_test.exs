defmodule Codex.EEPROMWriterTest do
  use ExUnit.Case

  test "can connect to a firmata board" do
    {:ok, firmata } = Codex.EEPROMWriter.start_link("COM6")
  end
end