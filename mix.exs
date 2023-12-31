defmodule DomHelpers.MixProject do
  use Mix.Project

  @version "0.3.1"
  @source_url "https://github.com/Serabe/dom_helpers"

  def project do
    [
      app: :dom_helpers,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      docs: docs(),
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
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:phoenix_live_view, "~> 0.19"}
    ]
  end

  defp docs do
    [
      extras: [
        {:"README.md", [title: "Overview"]},
        {:"guides/cheatsheets/accessors.cheatmd", [title: "Accessors"]},
        {:"guides/cheatsheets/assertions.cheatmd", [title: "Assertions"]},
        {:"guides/cheatsheets/selectors.cheatmd", [title: "Selectors"]}
      ],
      groups_for_extras: [Cheatsheets: ~r/cheatsheets\/.?/],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}"
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_other), do: ["lib"]
end
