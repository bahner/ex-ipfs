import Config

config :myspace_ipfs,
  api_url: System.get_env("MYSPACE_IPFS_API_URL", "http://localhost:5001/api/v0")
