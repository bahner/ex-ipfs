import Config

config :ex_ipfs,
  api_url: "http://localhost:5001/api/v0"

import_config "#{config_env()}.exs"
