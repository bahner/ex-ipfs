import Config

config :tesla,
  adapter: Tesla.Adapter.Hackney

config :myspace_ipfs,
  api_url: "http://localhost:5001/api/v0",
  default_topic: "ubXlzcGFjZQ"

config :logger,
  compile_time_purge_matching: [
    [level_lower_than: :error]
  ]
