defmodule Brewbase.Repo.Migrations.CreateFermenter do
  use Ecto.Migration

  def change do
    create table(:fermenters) do
      add :name, :string, default: ""
      add :description, :text, default: ""
      add :volume, :decimal
      add :units, :integer
      add :type, :integer
      add :is_active, :boolean, default: true, null: false
      add :is_available, :boolean, default: true, null: false
      add :user_id, references(:users, on_delete: :nilify_all), null: true

      timestamps()
    end
    create index(:fermenters, [:user_id])

  end
end
