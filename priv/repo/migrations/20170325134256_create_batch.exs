defmodule Brewbase.Repo.Migrations.CreateBatch do
  use Ecto.Migration

  def change do
    create table(:batches) do
      add :name, :string
      add :brew_notes, :text
      add :tasting_notes, :text
      add :brew_date, :utc_datetime, null: true
      add :secondary_fermenter_date, :utc_datetime, null: true
      add :bottle_date, :utc_datetime, null: true
      add :estimated_bottling_date, :utc_datetime, null: true
      add :estimated_drinkable_date, :utc_datetime, null: true
      add :original_gravity, :decimal, null: true
      add :final_gravity, :decimal, null: true
      add :recipe_url, :string
      add :user_id, references(:users, on_delete: :nilify_all), null: true
      add :fermenter_id, references(:fermenters, on_delete: :nilify_all), null: true
      add :boil_volume, :decimal, null: true
      add :fermenter_volume, :decimal, null: true
      add :bottled_volume, :decimal, null: true
      add :volume_units, :integer, null: true

      timestamps()
    end
    create index(:batches, [:user_id])
    create index(:batches, [:fermenter_id])

  end
end
