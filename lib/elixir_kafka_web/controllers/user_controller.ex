defmodule ElixirKafkaWeb.UserController do
  use ElixirKafkaWeb, :controller

  alias ElixirKafkaPubsub.Publisher

  def show(conn, _params) do
    conn
    |> put_status(:ok)
    |> render(:index, users: ElixirKafka.User.get_all())
  end

  def create(conn, _params) do
    case ElixirKafka.User.insert(conn.body_params) do
      {:ok, user} ->
        Publisher.publish("api-users.create", "teste", "hello world")

        conn
        |> put_status(:created)
        |> render(:show, user: user)

      {:error, _changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: "invalid data"})
    end
  end

  def update(conn, %{"id" => id}) do
    case ElixirKafka.User.update(String.to_integer(id), conn.body_params) do
      {:ok, _user} ->
        resp(conn, :ok, "")

      {:error, :not_found} ->
        resp(conn, :not_found, "")
    end
  end

  def delete(conn, %{"id" => id}) do
    case ElixirKafka.User.delete(String.to_integer(id)) do
      {:ok, _user} ->
        resp(conn, :ok, "")

      {:error, :not_found} ->
        resp(conn, :not_found, "")
    end
  end
end
