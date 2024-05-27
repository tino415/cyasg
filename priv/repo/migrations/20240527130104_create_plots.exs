defmodule Cyasg.Repo.Migrations.CreatePlots do
  use Ecto.Migration

  def change do
    create table(:plots, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :dataset, :string
      add :expression, :string
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end
  end
end
