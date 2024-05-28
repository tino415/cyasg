defmodule Cyasg.Plots do
  use Cyasg.Context

  alias Cyasg.Datasets
  alias Cyasg.Plots.Plot

  def list_user_plots(user_id) do
    Repo.all(from(p in Plot, where: p.user_id == ^user_id))
  end

  def get_user_plot!(user_id, id) do
    plot = Repo.get_by!(Plot, user_id: user_id, id: id)
    %Plot{plot | columns: Datasets.columns(plot.dataset)}
  end

  # TODO: make consistent, either send structs or ids everywhere
  def create_user_plot(user_id, attrs \\ %{}) do
    %Plot{user_id: user_id}
    |> Plot.changeset(attrs)
    |> Repo.insert()
  end

  def update_user_plot(user_id, %Plot{user_id: user_id} = plot, attrs) do
    plot
    |> Plot.changeset(attrs)
    |> Repo.update()
  end

  def delete_user_plot(user_id, %Plot{user_id: user_id} = plot) do
    Repo.delete(plot)
  end

  def change_plot(%Plot{} = plot, attrs \\ %{}) do
    Plot.changeset(plot, attrs)
  end
end
