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
        main: "Notionex",
        groups_for_modules: [
          "API Client": [
            Notionex.API,
            Notionex.API.Client,
            Notionex.API.HTTPoisonClient,
            Notionex.API.Request
          ],
          Renderer: [Notionex.Renderer, Notionex.Renderer.HTMLRenderer],
          "Notion Objects": [
            Notionex.Object,
            Notionex.Object.Block,
            Notionex.Object.Page,
            Notionex.Object.List,
            Notionex.Object.User,
            Notionex.Object.Parent,
            Notionex.Object.File
          ]
        ],
        groups_for_docs: [
          # Home Page
          "API Client": &(&1[:feature] == :api),
          Renderer: &(&1[:feature] == :renderer),
          # API Client
          "Block Endpoints": &(&1[:endpoint] == :block),
          "Page Endpoints": &(&1[:endpoint] == :page),
          "Database Endpoints": &(&1[:endpoint] == :database)
        ]
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
