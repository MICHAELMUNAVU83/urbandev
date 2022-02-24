defmodule Urbandev.MixProject do
  use Mix.Project

  def project do
    [
      app: :urbandev,
      version: "0.1.0",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Urbandev.Application, []},
      applications: [
        :phoenix,
        :phoenix_html,
        :postgrex,
        :cowboy,
        :ecto,
        :ecto_sql,
        :bcrypt_elixir,
        :gettext,
        :phoenix_ecto,
        :myxql,
        :comeonin,
        :phoenix_live_reload,
        :telemetry_metrics,
        :phoenix_live_view,
        :phoenix_live_dashboard,
        :rummage_ecto,
        :rummage_phoenix,
        :pdf_generator,
        :sendgrid,
        :ibrowse,
        :quantum,
        :httpotion,
        :poison,
        :json_web_token,
        :arc_ecto,
        :arc,
        :secure_random,
        :timex
      ],
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [

      {:bcrypt_elixir, "~> 2.0"},
      {:plug_cowboy, "~> 2.5"},
      {:db_connection, "~> 2.2.1", override: true},
      {:phoenix, "~> 1.5.6", override: true},
      {:telemetry, "~> 0.4.0", override: true},
      {:phoenix_ecto, "~> 4.1.0", override: true},
      {:jason, "~> 1.0", override: true},
      {:ecto_sql, "~> 3.7.1"},
      {:ecto, "~> 3.4.0", override: true},
      {:myxql, "~> 0.3.0", override: true},
      {:mnemonic_slugs, "~> 0.0.3"},
      {:phoenix_live_view, "~> 0.16.4"},
      {:phoenix_html, "~> 3.0", override: true},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.5"},
      {:phx_gen_auth, "~> 0.5", only: [:dev], runtime: false},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:ibrowse, "~> 4.4.0" , override: true},
      {:cowboy, "~> 2.7"},
      {:gettext, "~> 0.11"},
      {:decimal, "~> 2.0", override: true},
      {:postgrex, "~> 0.10.0", override: true},
      {:arc, "~> 0.11.0"},
      {:arc_ecto, "~> 0.11.0"},
      {:rummage_ecto, "~> 1.0.0", override: true},
      {:rummage_phoenix, "~> 1.2.0", override: true},
      {:qrcode, "~> 1.0.4", git: "https://github.com/netflakes/qrcode.git"},
      {:pdf_generator, ">=0.3.7"},
      {:secure_random, "~> 0.5"},
      {:quantum, "~> 3.0"},
      {:httpoison, "~> 1.8"},
      {:httpotion, "~> 3.1.0"},
      {:timex, "~> 3.7.6"},
      {:poison, "~> 5.0.0", override: true},
      {:json_web_token, "~> 0.2"},
      {:sendgrid, "~> 2.0"},
      {:edeliver, "~> 1.4.3"},
      {:distillery, "~> 1.4"}

    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
