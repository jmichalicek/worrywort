defmodule Brewbase.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string, default: "", null: false
      add :last_name, :string, default: "", null: false
      add :email, :string, null: false
      add :hashed_password, :string, default: "", null: false
      add :is_active, :boolean, default: false, null: false
      add :last_login, :utc_datetime, null: true

      timestamps()
    end
    create unique_index(:users, [:email])

  end
end
