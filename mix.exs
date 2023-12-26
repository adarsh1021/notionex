defmodule Notionex.MixProject do
  use Mix.Project

  def project do
    [
      app: :notionex,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "A Notion API client and block renderer for Elixir",
      package: [
        licenses: ["MIT"],
        links: %{}
      ],
      docs: [
        main: "Notionex"
      ]
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
      {:httpoison, "~> 2.2.1"},
      {:jason, "~> 1.4.1"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end
end
