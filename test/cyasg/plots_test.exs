defmodule Cyasg.PlotsTest do
  use Cyasg.DataCase

  alias Cyasg.Plots

  describe "plots" do
    alias Cyasg.Plots.Plot

    import Cyasg.PlotsFixtures
    import Cyasg.AccountsFixtures

    @invalid_attrs %{name: nil, dataset: nil, expression: nil}

    test "list_user_plots/1 returns all users plots" do
      user = user_fixture()
      plot = plot_fixture(user)
      assert Plots.list_user_plots(user.id) == [Map.put(plot, :columns, nil)]
    end

    test "get_user_plot!/2 returns the plot with given id" do
      user = user_fixture()
      plot = plot_fixture(user)
      assert Plots.get_user_plot!(user.id, plot.id) == plot
    end

    test "create_user_plot/3 with valid data creates a plot" do
      user = user_fixture()

      valid_attrs = %{
        name: "some name",
        dataset: "2011_february_aa_flight_paths",
        expression: "'start_lat'",
        prerendered_image: "test"
      }

      assert {:ok, %Plot{} = plot} = Plots.create_user_plot(user.id, [], valid_attrs)
      assert plot.name == "some name"
      assert plot.dataset == "2011_february_aa_flight_paths"
      assert plot.expression == "'start_lat'"
    end

    test "create_user_plot/3 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Plots.create_user_plot(user, [], @invalid_attrs)
    end

    test "update_user_plot/4 with valid data updates the plot" do
      user = user_fixture()
      plot = plot_fixture(user)

      update_attrs = %{
        name: "some updated name",
        dataset: "2011_february_aa_flight_paths",
        expression: "'start_lat'"
      }

      assert {:ok, %Plot{} = plot} = Plots.update_user_plot(user.id, plot, [], update_attrs)
      assert plot.name == "some updated name"
      assert plot.dataset == "2011_february_aa_flight_paths"
      assert plot.expression == "'start_lat'"
    end

    test "update_user_plot/4 with invalid data returns error changeset" do
      user = user_fixture()
      plot = plot_fixture(user)

      assert {:error, %Ecto.Changeset{}} = Plots.update_user_plot(user.id, plot, [], @invalid_attrs)
      assert plot == Plots.get_user_plot!(user.id, plot.id)
    end

    test "delete_user_plot/2 deletes the plot" do
      user = user_fixture()
      plot = plot_fixture(user)

      assert {:ok, %Plot{}} = Plots.delete_user_plot(user.id, plot)
      assert_raise Ecto.NoResultsError, fn -> Plots.get_user_plot!(user.id, plot.id) end
    end

    test "change_plot/1 returns a plot changeset" do
      user = user_fixture()
      plot = plot_fixture(user)

      assert %Ecto.Changeset{} = Plots.change_plot(plot)
    end
  end
end
