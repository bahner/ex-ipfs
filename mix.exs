defmodule IpfsElixir.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ipfs_elixir,
      version: "0.1.0",
      elixir: "~> 1.5",
      name: "IPFS Elixir",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :tesla]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 0.9.0"},
      {:poison, "~> 3.1"},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false}
    ]
  end
end
