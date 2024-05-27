defmodule Cyasg.Repo do
  use Ecto.Repo,
    otp_app: :cyasg,
    adapter: Ecto.Adapters.Postgres
end
