defmodule MyspaceIPFS.Mixfile do
  use Mix.Project

  def project do
    [
      app: :myspace_ipfs,
      version: "0.1.0-alpha.1",
      elixir: "~> 1.11",
      name: "Myspace IPFS",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      name: "myspace_ipfs",
      source_url: "https://github.com/bahner/myspace-ipfs.git"
    ]
  end

  def application do
    [
      extra_applications: [:logger, :tesla]
    ]
  end

  defp deps do
    [
      {:tesla, "~> 1.4"},
      {:jason, "~> 1.4"},
      {:nanoid, "~> 2.0"},
      {:ex_doc, "~> 0.29", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "An IPFS RPC API wrapper"
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
