import Config

config :ex_ipfs,
  api_url: System.get_env("EX_IPFS_API_URL", "http://localhost:5001/api/v0")
