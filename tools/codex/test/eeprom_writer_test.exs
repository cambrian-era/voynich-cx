defmodule Codex.EEPROMWriterTest do
  use ExUnit.Case

  describe "the firmata module" do
    test "can connect to a firmata board" do
      {response, _pid} = Codex.EEPROMWriter.start_link("COM6")

      assert response == :ok
    end

    test "can initialize i2c" do
      Codex.EEPROMWriter.init_i2c()
    end

    test "can initialize pins" do
      Codex.EEPROMWriter.init_pins()
    end
  end
end
