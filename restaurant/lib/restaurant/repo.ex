defmodule Restaurant.Repo do
  use Ecto.Repo,
    otp_app: :restaurant,
    adapter: Ecto.Adapters.Postgres
end
