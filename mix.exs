defmodule DomHelpers.MixProject do
  use Mix.Project

  @version "0.1.1"

  def project do
    [
      app: :dom_helpers,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      license: "MIT",
      package: package()
    ]
  end

  def package do
    [
      maintainers: ["Sergio Arbeo"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Serabe/dom_helpers"},
      files: ~w(lib LICENSE.txt mix.exs README.md),
      description: "A collection of helpers to work with DOM in tests."
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:floki, "~> 0.34.0"},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_other), do: ["lib"]
end
