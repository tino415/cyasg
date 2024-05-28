defmodule CyasgWeb.SharingLiveTest do
  use CyasgWeb.ConnCase

  import Phoenix.LiveViewTest
  import Cyasg.SharingsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_sharing(_) do
    sharing = sharing_fixture()
    %{sharing: sharing}
  end

  describe "Index" do
    setup [:create_sharing]

    test "lists all sharings", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/sharings")

      assert html =~ "Listing Sharings"
    end

    test "saves new sharing", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/sharings")

      assert index_live |> element("a", "New Sharing") |> render_click() =~
               "New Sharing"

      assert_patch(index_live, ~p"/sharings/new")

      assert index_live
             |> form("#sharing-form", sharing: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#sharing-form", sharing: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sharings")

      html = render(index_live)
      assert html =~ "Sharing created successfully"
    end

    test "updates sharing in listing", %{conn: conn, sharing: sharing} do
      {:ok, index_live, _html} = live(conn, ~p"/sharings")

      assert index_live |> element("#sharings-#{sharing.id} a", "Edit") |> render_click() =~
               "Edit Sharing"

      assert_patch(index_live, ~p"/sharings/#{sharing}/edit")

      assert index_live
             |> form("#sharing-form", sharing: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#sharing-form", sharing: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sharings")

      html = render(index_live)
      assert html =~ "Sharing updated successfully"
    end

    test "deletes sharing in listing", %{conn: conn, sharing: sharing} do
      {:ok, index_live, _html} = live(conn, ~p"/sharings")

      assert index_live |> element("#sharings-#{sharing.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#sharings-#{sharing.id}")
    end
  end

  describe "Show" do
    setup [:create_sharing]

    test "displays sharing", %{conn: conn, sharing: sharing} do
      {:ok, _show_live, html} = live(conn, ~p"/sharings/#{sharing}")

      assert html =~ "Show Sharing"
    end

    test "updates sharing within modal", %{conn: conn, sharing: sharing} do
      {:ok, show_live, _html} = live(conn, ~p"/sharings/#{sharing}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Sharing"

      assert_patch(show_live, ~p"/sharings/#{sharing}/show/edit")

      assert show_live
             |> form("#sharing-form", sharing: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#sharing-form", sharing: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/sharings/#{sharing}")

      html = render(show_live)
      assert html =~ "Sharing updated successfully"
    end
  end
end
