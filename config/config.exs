import Config

config :tesla, adapter: {Tesla.Adapter.Hackney, [max_body: 1_000_000_000]}

config :myspace_ipfs,
  baseurl: "http://localhost:5001/api/v0",
  experimental: true,
  deprecated: false,
  debug: false

import_config "#{Mix.env()}.exs"
