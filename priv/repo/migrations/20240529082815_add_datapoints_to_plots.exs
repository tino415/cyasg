defmodule Cyasg.Repo.Migrations.AddDatapointsToPlots do
  use Ecto.Migration

  def change do
    alter table(:plots) do
      add :datapoints, {:array, :decimal}, default: []
    end
  end
end
