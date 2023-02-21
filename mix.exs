defmodule ExIPFS.Mixfile do
  @moduledoc false
  use Mix.Project

  def project do
    [
      app: :ex_ipfs,
      version: "0.0.1",
      elixir: "~> 1.14",
      name: "Elixir IPFS",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      name: "ex_ipfs",
      source_url: "https://github.com/bahner/ex-ipfs.git",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :tesla],
      mod: {ExIPFS.Application, []}
    ]
  end

  defp deps do
    [
      {:hackney, "~> 1.18"},
      {:jason, "~> 1.4"},
      {:nanoid, "~> 2.0"},
      {:recase, "~> 0.7.0"},
      {:tesla, "~> 1.5"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.2", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.29", only: :dev, runtime: false},
      {:excoveralls, "~> 0.15", only: :test, runtime: false}
    ]
  end

  defp description() do
    "Core Elixir IPFS module for Kubo IPFS RPC API"
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*", "AUTHORS*"],
      maintainers: ["Lars Bahner"],
      licenses: ["GPLv3"],
      links: %{"GitHub" => "https://github.com/bahner/ex-ipfs"}
    ]
  end
end
