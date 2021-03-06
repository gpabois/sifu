import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :pbkdf2_elixir, :rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :sifu, Sifu.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "sifu_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :workflow, Workflow.Repo,
  username: "postgres",
  password: "postgres",
  database: "workflow_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sifu, SifuWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "SFcp9CMq2Lg+wTaTaa6kqY3c1weNGQazYHuZ7uZrP84t7Blix0CY2TkWLCJUECod",
  server: false

# In test we don't send emails.
config :sifu, Sifu.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
