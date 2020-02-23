defmodule Moody.Repo do
  use Ecto.Repo,
    otp_app: :moody,
    adapter: Ecto.Adapters.Postgres
end
