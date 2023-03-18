defmodule NPlusOne.Repo do
  use Ecto.Repo,
    otp_app: :n_plus_one,
    adapter: Ecto.Adapters.SQLite3
end
