defmodule Codex.CLI do
  def main(args) do
    {opts, _, _} = OptionParser.parse(args, switches: [output: :string], aliases: [o: :output])
    # here I just print the options 
    IO.inspect(opts)
  end
end
