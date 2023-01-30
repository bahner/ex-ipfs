import Config

config :tesla,
  adapter: {Tesla.Adapter.Hackney, recv_timeout: 60_000}

config :logger,
  level: :debug
