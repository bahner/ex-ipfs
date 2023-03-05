import Config

config :ex_ipfs,
  api_url: "http://127.0.0.1:5001/api/v0"

import_config "#{config_env()}.exs"
