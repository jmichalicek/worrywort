# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :brewbase,
  ecto_repos: [Brewbase.Repo]

# Configures the endpoint
config :brewbase, Brewbase.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "iJXS1gZLb3tT8gzau5XQjT0AYAjVJxfpmGv+WB9a6LwIUUXNsPnwFa1TzlL4eYgD",
  render_errors: [view: Brewbase.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Brewbase.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# will this config for identity cause problems with other auth types?
config :ueberauth, Ueberauth,
  base_path: "/",  #default is /auth
  providers: [
    identity: { Ueberauth.Strategy.Identity, [
        callback_methods: ["POST"],
        uid_field: :email,
        nickname_field: :email,
        request_path: "/login",
        callback_path: "/login",
        param_nesting: "auth"
      ] }
  ]

config :invitatr, Invitatr.Mailer,
  adapter: Bamboo.LocalAdapter
  #adapter: Bamboo.SMTPAdapter,
  #server: System.get_env("SMTP_HOST"),
  #port: System.get_env("SMTP_PORT"),
  #username: System.get_env("SMTP_USERNAME"),
  #password: System.get_env("SMTP_PASSWORD"),
  #tls: :if_available,
  #ssl: false,retries: 1

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
