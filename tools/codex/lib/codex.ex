defmodule Codex do
  @moduledoc """
  Documentation for CompileRom.
  """

  def start(_type, _args) do
  end

  def compile(path) do
    charset = Codex.Charset.load(Path.join([__DIR__, "../data/voyscii.tga"]))
    IO.inspect(charset)
  end
end
