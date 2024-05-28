defmodule Cyasg.Sharings do
  import Ecto.Query, warn: false
  alias Cyasg.Repo

  alias Cyasg.Sharings.Sharing
  alias Ecto.Changeset

  def list_sharings do
    Repo.all(Sharing)
    |> Repo.preload(:plot)
  end

  def get_sharing!(id), do: Repo.get!(Sharing, id)

  def create_sharing(plot, attrs \\ %{}) do
    %Sharing{plot: plot}
    |> Sharing.changeset(attrs)
    |> Repo.insert()
  end

  def update_sharing(%Sharing{} = sharing, attrs) do
    sharing
    |> Sharing.changeset(attrs)
    |> Repo.update()
  end

  def delete_sharing(%Sharing{} = sharing) do
    Repo.delete(sharing)
  end

  def new_sharing(attrs \\ %{}) do
    Sharing.changeset(%Sharing{user: nil, plot: nil, user_id: nil, plot_id: nil}, attrs)
  end

  def change_sharing(%Sharing{} = sharing, attrs \\ %{}) do
    Sharing.changeset(sharing, attrs)
  end
end
