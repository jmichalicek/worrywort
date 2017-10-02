defmodule Brewbase.Mixfile do
  use Mix.Project

  def project do
    [app: :brewbase,
     version: "0.0.1",
     elixir: "~> 1.5",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     build_path: "/home/developer/_worrywort_build_dir",
     aliases: aliases(),
     deps: deps()]
  end


  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  #def application do
  #  [mod: {Brewbase, []},
  #   applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
  #                  :phoenix_ecto, :postgrex]]
  #end

  def application do
    [mod: {Brewbase, []},
     applications: app_list(Mix.env)]
  end
  defp app_list(:test), do: app_list() ++ [:ex_machina]
  defp app_list(_), do: app_list()
  defp app_list, do: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy,
   :logger, :gettext, :phoenix_ecto, :postgrex, :comeonin, :ueberauth,
   :ueberauth_identity, :tzdata, :calendar, :bamboo, :bamboo_smtp, :phoenix_users,
   :absinthe,]

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.3"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.3.0"},
     {:postgrex, ">= 0.13.3"},
     {:phoenix_html, "~> 2.10"},
     {:phoenix_live_reload, "~> 1.1", only: :dev},
     {:gettext, "~> 0.13"},
     {:cowboy, "~> 1.1"},
     # my deps
     {:ueberauth, "~> 0.4"},
     {:ueberauth_identity, "~>0.2"},
     {:calendar, "~> 0.17.2"},
     {:calecto, "~> 0.16.0"},
     {:comeonin, "~> 4.0"},
     {:bcrypt_elixir, "~> 1.0"},
     {:ex_machina, "~> 2.1"},
     {:bamboo, "~> 0.8"},
     {:bamboo_smtp, "~> 1.4.0"},
     {:guardian, "~> 0.14"},
     {:absinthe, "~> 1.3"},
     {:absinthe_plug, "~> 1.3"},
     #{:absinthe_ecto, git: "https://github.com/absinthe-graphql/absinthe_ecto.git"},
     {:absinthe_ecto, "~> 0.1.2"},
     # dev stuff
     {:phoenix_users, git: "https://github.com/jmichalicek/phoenix_users.git",
      ref: "b672861affa52b4760a3338b1c1a5bde8b2aa254"},
   ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
