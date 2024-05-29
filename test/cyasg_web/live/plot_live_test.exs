defmodule CyasgWeb.PlotLiveTest do
  use CyasgWeb.ConnCase

  import Phoenix.LiveViewTest
  import Cyasg.AccountsFixtures
  import Cyasg.PlotsFixtures

  @create_attrs %{
    name: "some name",
    dataset: "2011_february_aa_flight_paths",
    expression: "'start_lat'"
  }

  @update_attrs %{
    name: "some updated name",
    dataset: "2010_alcohol_consumption_by_country",
    expression: "'alcohol'"
  }

  @invalid_attrs %{
    name: nil,
    dataset: "2010_alcohol_consumption_by_country",
    expression: nil
  }

  defp create_plot(_) do
    user = user_fixture()
    plot = plot_fixture(user)
    %{plot: plot, user: user}
  end

  defp login_conn(%{conn: conn, user: current_user}) do
    %{conn: log_in_user(conn, current_user)}
  end

  describe "Index" do
    setup [:create_plot, :login_conn]

    test "lists all plots", %{conn: conn, plot: plot} do
      {:ok, _index_live, html} = live(conn, ~p"/plots")

      assert html =~ "Listing Plots"
      assert html =~ plot.name
    end

    @tag skip: true
    test "saves new plot", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/plots")

      assert index_live |> element("a", "New Plot") |> render_click() =~
               "New Plot"

      assert_patch(index_live, ~p"/plots/new")

      element(index_live, "#plot") |> render_hook("image-src", %{src: "test:value"})

      assert index_live
             |> form("#plot-form", plot: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      element(index_live, "#plot") |> render_hook("image-src", %{src: "test:value"})

      assert index_live
             |> form("#plot-form", plot: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/plots")

      html = render(index_live)
      assert html =~ "Plot created successfully"
      assert html =~ "some name"
    end

    test "updates plot in listing", %{conn: conn, plot: plot} do
      {:ok, index_live, _html} = live(conn, ~p"/plots")

      assert index_live |> element("#plots-#{plot.id} a", "Edit") |> render_click() =~
               "Edit Plot"

      assert_patch(index_live, ~p"/plots/#{plot}/edit")

      assert index_live
             |> form("#plot-form", plot: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#plot-form", plot: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/plots")

      html = render(index_live)
      assert html =~ "Plot updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes plot in listing", %{conn: conn, plot: plot} do
      {:ok, index_live, _html} = live(conn, ~p"/plots")

      assert index_live |> element("#plots-#{plot.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#plots-#{plot.id}")
    end
  end

  describe "Show" do
    setup [:create_plot, :login_conn]

    test "displays plot", %{conn: conn, plot: plot} do
      {:ok, _show_live, html} = live(conn, ~p"/plots/#{plot}")

      assert html =~ "Show Plot"
      assert html =~ plot.name
    end

    @tag skip: true
    test "updates plot within modal", %{conn: conn, plot: plot} do
      {:ok, show_live, _html} = live(conn, ~p"/plots/#{plot}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Plot"

      assert_patch(show_live, ~p"/plots/#{plot}/show/edit")

      assert show_live
             |> form("#plot-form", plot: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#plot-form", plot: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/plots/#{plot}")

      html = render(show_live)
      assert html =~ "Plot updated successfully"
      assert html =~ "some updated name"
    end
  end
end
