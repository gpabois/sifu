defmodule Sifu.Repo do
  use Ecto.Repo,
    otp_app: :sifu,
    adapter: Ecto.Adapters.Postgres
end
