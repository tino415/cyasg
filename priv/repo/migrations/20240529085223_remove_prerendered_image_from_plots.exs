defmodule Cyasg.Repo.Migrations.RemovePrerenderedImageFromPlots do
  use Ecto.Migration

  def change do
    alter table(:plots) do
      remove :prerendered_image
    end
  end
end
