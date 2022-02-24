defmodule Urbandev.Repo do
  use Ecto.Repo,
    otp_app: :urbandev,
    adapter: Ecto.Adapters.MyXQL
end
