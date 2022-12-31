import Config

config :tesla,
  adapter: Tesla.Adapter.Hackney

config :myspace_ipfs,
  baseurl: "http://localhost:5001/api/v0",
  experimental: true,
  deprecated: false,
  debug: false

import_config "#{Mix.env()}.exs"
