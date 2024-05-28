defmodule Cyasg.Repo.Migrations.CreateSharings do
  use Ecto.Migration

  def change do
    create table(:sharings, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false
      add :plot_id, references(:plots, type: :uuid, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:sharings, [:user_id])
    create index(:sharings, [:plot_id])
    create unique_index(:sharings, [:user_id, :plot_id])
  end
end
