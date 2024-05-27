defmodule Cyasg.Repo.Migrations.AddPrerenderedImageToPlots do
  use Ecto.Migration

  def change do
    alter table(:plots) do
      add :prerendered_image, :text
    end
  end
end
