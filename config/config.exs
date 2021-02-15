# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :arryzmia, ArryzmiaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Vy1wlr/2Dbqq4L0RzxyFFfPXingGOwMyhLZ8Wm1zqqYo+0obxNMeHK3C/Yg853TS",
  render_errors: [view: ArryzmiaWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Arryzmia.PubSub,
  live_view: [signing_salt: "rcp2iWMG"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason


config :arryzmia, Arryzmia,
  github_token: System.get_env("GITHUB_TOKEN")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
