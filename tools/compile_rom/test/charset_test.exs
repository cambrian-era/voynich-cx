defmodule CompileRom.CharsetTest do
  use ExUnit.Case
  doctest CompileRom.Charset

  test "loads a TGA file" do
    CompileRom.Charset.load(Path.join([__DIR__, "../data/voyscii.tga"]))
  end
end