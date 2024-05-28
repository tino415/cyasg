defmodule Cyasg.Sharings do
  use Cyasg.Context

  alias Cyasg.Sharings.Sharing

  def list_shared_with_user(user_id) do
    from(s in Sharing, where: s.user_id == ^user_id)
    |> Repo.all()
    |> Repo.preload(plot: :user)
  end

  def list_plot_sharings(plot_id) do
    from(s in Sharing, where: s.plot_id == ^plot_id)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  def get_sharing!(id) do
    Repo.get!(Sharing, id)
    |> Repo.preload(plot: :user)
  end

  def create_plot_sharing(plot, attrs \\ %{}) do
    ok_sharing =
      %Sharing{plot: plot}
      |> Sharing.changeset(attrs)
      |> Repo.insert()

    with {:ok, sharing} <- ok_sharing do
      {:ok, Repo.preload(sharing, :user)}
    end
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
