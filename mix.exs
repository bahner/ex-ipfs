defmodule IpfsElixir.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ipfs_elixir,
      version: "0.0.4",
      elixir: "~> 1.5",
      name: "IPFS Elixir",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package,
      description: description(),
      name: "Ipfs_Elixir_Api",
      source_url: "https://github.com/tensor-programming/Elixir-Ipfs-Api"
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

  defp description() do
    "An Ipfs API wrapper build in Elixir"
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Jeremiah King"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/tensor-programming/Elixir-Ipfs-Api"}
    ]
  end
end
