defmodule ElixirKafka.Repo do
  use Ecto.Repo,
    otp_app: :elixir_kafka,
    adapter: Ecto.Adapters.Postgres
end
