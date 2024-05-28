defmodule Cyasg.PlotsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cyasg.Plots` context.
  """

  @doc """
  Generate a plot.
  """
  def plot_fixture(user, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        dataset: "2011_february_aa_flight_paths",
        expression: "'start_lat'",
        name: "some name",
        prerendered_image: "test:valuie"
      })

    {:ok, plot} = Cyasg.Plots.create_user_plot(user.id, attrs)

    plot
  end
end
