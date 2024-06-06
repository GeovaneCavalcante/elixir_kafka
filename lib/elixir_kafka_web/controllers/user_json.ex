defmodule ElixirKafkaWeb.UserJSON do
  alias ElixirKafka.User

  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      name: user.name,
      age: user.age,
      email: user.email,
      password: user.password
    }
  end
end
