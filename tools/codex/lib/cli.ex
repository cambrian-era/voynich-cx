defmodule Codex.CLI do
  def main(args) do
    {opts, _, _} =
      OptionParser.parse(args,
        switches: [output: :string, upload: :boolean, port: :string, file: :string],
        aliases: [o: :output, u: :upload, p: :port, f: :file]
      )

    IO.inspect(opts)

    cond do
      Keyword.has_key?(opts, :output) ->
        Codex.compile(opts[:output])
    end
  end
end
