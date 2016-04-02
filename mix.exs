defmodule Bees.Mixfile do
  use Mix.Project

  def project do
    [app: :bees,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :httpoison, :jsx, :plug, :poison]]
  end
  
  defp deps do
    [
      {:httpoison, "~> 0.8.0"},
      {:jsx, "~> 2.6"},
      {:plug, "~> 1.0"},
      {:poison, "~> 2.0"},
      {:exvcr, "~> 0.7", only: :test}
    ]
  end
end