# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :simple_chat,
  ecto_repos: [SimpleChat.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :simple_chat, SimpleChatWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: SimpleChatWeb.ErrorHTML, json: SimpleChatWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: SimpleChat.PubSub,
  live_view: [signing_salt: "UWFZnN1m"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :simple_chat, SimpleChat.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.25.4",
  simple_chat: [
    args:
      ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ],
  simple_chat_inertia: [
    args:
      ~w(js/application_inertia.jsx --bundle --chunk-names=chunks/[name]-[hash] --splitting --format=esm --target=es2022 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ],
  ssr: [
    args: ~w(js/ssr.jsx --bundle --platform=node --outdir=../priv --format=cjs),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "4.1.7",
  simple_chat: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/css/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ],
  simple_chat_inertia: [
    args: ~w(
      --input=assets/css/application_inertia.css
      --output=priv/static/assets/css/application_inertia.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Inertia configuration
# config/config.exs

config :inertia,
  # The Phoenix Endpoint module for your application. This is used for building
  # asset URLs to compute a unique version hash to track when something has
  # changed (and a reload is required on the frontend).
  endpoint: SimpleChatWeb.Endpoint,

  # An optional list of static file paths to track for changes. You'll generally
  # want to include any JavaScript assets that may require a page refresh when
  # modified.
  static_paths: ["/assets/app_inertia.js"],

  # The default version string to use (if you decide not to track any static
  # assets using the `static_paths` config). Defaults to "1".
  default_version: "1",

  # Enable automatic conversion of prop keys from snake case (e.g. `inserted_at`),
  # which is conventional in Elixir, to camel case (e.g. `insertedAt`), which is
  # conventional in JavaScript. Defaults to `false`.
  camelize_props: true,

  # Instruct the client side whether to encrypt the page object in the window history
  # state. This can also be set/overridden on a per-request basis, using the `encrypt_history`
  # controller helper. Defaults to `false`.
  history: [encrypt: false],

  # Enable server-side rendering for page responses (requires some additional setup,
  # see instructions below). Defaults to `false`.
  ssr: false,

  # Whether to raise an exception when server-side rendering fails (only applies
  # when SSR is enabled). Defaults to `true`.
  #
  # Recommended: enable in non-production environments and disable in production,
  # so that SSR failures will not cause 500 errors (but instead will fallback to
  # CSR).
  raise_on_ssr_failure: config_env() != :prod

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
