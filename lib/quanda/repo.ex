defmodule Quanda.Repo do
  use Ecto.Repo,
    otp_app: :quanda,
    adapter: Ecto.Adapters.Postgres
end
