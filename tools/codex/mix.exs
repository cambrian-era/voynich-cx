defmodule Codex.MixProject do
  use Mix.Project

  def project do
    [
      app: :codex,
      version: "0.1.0",
      elixir: "~> 1.8",
      escript: [main_module: Codex.CLI],
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      #applications: [:firmata]
      # mod: {Codex.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:intel_hex, "~> 0.1.0"},
      #{:firmata, "~> 0.0.2"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
