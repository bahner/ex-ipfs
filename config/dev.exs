import Config

config :tesla, Tesla.Middleware.Logger, debug: true

config :myspace_ipfs,
  baseurl: "http://localhost:5001/api/v0",
  debug: true,
  experimental: true
