defmodule Codex.CharsetTest do
  use ExUnit.Case
  doctest Codex.Charset

  test "loads a TGA file" do
    {:ok, charset} = Codex.Charset.load(Path.join([__DIR__, "../data/voyscii.tga"]))

    assert(Map.has_key?(charset, :palette))
    assert(Map.has_key?(charset, :chars))

    assert(Enum.count(charset.chars) == 256)
    assert(Enum.count(charset.palette) == 16)
  end
end
