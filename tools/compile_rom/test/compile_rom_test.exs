defmodule CompileRomTest do
  use ExUnit.Case
  doctest CompileRom

  test "greets the world" do
    assert CompileRom.hello() == :world
  end
end
