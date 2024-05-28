defmodule CyasgWeb.SharingLiveTest do
  use CyasgWeb.ConnCase

  import Phoenix.LiveViewTest

  import Cyasg.AccountsFixtures
  import Cyasg.PlotsFixtures
  import Cyasg.SharingsFixtures

  defp create_sharing(_) do
    user = user_fixture()
    plot = plot_fixture(user)
    user2 = user_fixture()
    sharing = sharing_fixture(plot, %{user_id: user2.id})

    %{sharing: sharing, user: user, current_user: user2, plot: plot}
  end

  defp login_conn(%{conn: conn, current_user: current_user}) do
    %{conn: log_in_user(conn, current_user)}
  end

  describe "Index" do
    setup [:create_sharing, :login_conn]

    test "lists all sharings", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/sharings")

      assert html =~ "Listing Sharings"
    end
  end

  describe "Show" do
    setup [:create_sharing, :login_conn]

    test "displays sharing", %{conn: conn, sharing: sharing} do
      {:ok, _show_live, html} = live(conn, ~p"/sharings/#{sharing}")

      assert html =~ "Show Sharing"
    end
  end
end
