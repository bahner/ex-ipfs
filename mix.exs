defmodule MyspaceIPFS.Mixfile do
  @moduledoc false
  use Mix.Project

  def project do
    [
      app: :myspace_ipfs,
      version: "0.2.0-alpha.2",
      elixir: "~> 1.13",
      name: "Myspace IPFS",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      name: "myspace_ipfs",
      source_url: "https://github.com/bahner/myspace-ipfs.git",
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
      mod: {MyspaceIPFS.Application, []}
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
    "A pretty good Kubo IPFS RPC API client for Elixir."
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*", "AUTHORS*"],
      maintainers: ["Lars Bahner"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/bahner/myspace-ipfs"}
    ]
  end
end
