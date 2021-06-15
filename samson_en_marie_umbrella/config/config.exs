# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :samson_en_marie,
  ecto_repos: [SamsonEnMarie.Repo]

config :samson_en_marie_web,
  ecto_repos: [SamsonEnMarie.Repo],
  generators: [context_app: :samson_en_marie]

# Configures the endpoint
config :samson_en_marie_web, SamsonEnMarieWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Rh90n0rucC5OHSM1HqUGWES1XwERu348x5YocWFyfwXhAcjZttZPbSN6YP2qLuk8",
  render_errors: [view: SamsonEnMarieWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: SamsonEnMarie.PubSub,
  live_view: [signing_salt: "nLu9P310"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :samson_en_marie_web, SamsonEnMarieWeb.Guardian,
  issuer: "samson_en_marie_web",
  secret_key: "awu1kQtwKqIc93yEFaHxD3Fw+KiTRCWEy6loj3m9OmKGnWjw1N771ciKoErKU8YZ"

config :translations, Translations.Gettext,
  locales: ~w(en nl), # ja stands for Japanese.
  default_locale: "en"
