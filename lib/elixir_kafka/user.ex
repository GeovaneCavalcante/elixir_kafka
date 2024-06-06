defmodule ElixirKafka.User do
  use Ecto.Schema

  alias ElixirKafka.Repo

  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :age, :integer
    field :email, :string
    field :password, :string
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :age, :email, :password])
    |> validate_required([:name, :age, :email, :password])
  end

  def get_all(), do: Repo.all(ElixirKafka.User)

  def find_by_id(id), do: Repo.get(ElixirKafka.User, id)

  def insert(user) do
    %ElixirKafka.User{}
    |> changeset(user)
    |> Repo.insert()
  end

  def update(id, data) do
    case find_by_id(id) do
      nil ->
        {:error, :not_found}

      user ->
        user
        |> changeset(data)
        |> Repo.update()
    end
  end

  def delete(id) do
    case find_by_id(id) do
      nil ->
        {:error, :not_found}

      user ->
        Repo.delete(user)
    end
  end
end
