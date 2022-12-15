import Config
#     Application.get_env(:myspace_ipfs, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
config :myspace_ipfs,
  baseurl: "http://localhost:5001/api/v0",
  experimental: true,
  deprecated: false

#import_config "#{Mix.env()}.exs"
