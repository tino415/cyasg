defmodule Cyasg.SharingsTest do
  use Cyasg.DataCase

  alias Cyasg.Sharings

  describe "sharings" do
    alias Cyasg.Sharings.Sharing

    import Cyasg.AccountsFixtures
    import Cyasg.PlotsFixtures
    import Cyasg.SharingsFixtures

    @invalid_attrs %{}

    test "list_plot_sharings/1 returns all sharings" do
      user = user_fixture()
      user2 = user_fixture()
      plot = plot_fixture(user)
      sharing = sharing_fixture(plot, %{user_id: user2.id})

      assert nil_assocs(Sharings.list_plot_sharings(plot.id)) == [nil_assocs(sharing)]
    end

    test "list_shared_with_user/1 returns all sharings" do
      user = user_fixture()
      user2 = user_fixture()
      plot = plot_fixture(user)
      sharing = sharing_fixture(plot, %{user_id: user2.id})

      assert nil_assocs(Sharings.list_shared_with_user(user2.id)) == nil_assocs([sharing])
    end

    test "get_sharing!/1 returns the sharing with given id" do
      user = user_fixture()
      plot = plot_fixture(user)
      user2 = user_fixture()
      sharing = sharing_fixture(plot, %{user_id: user2.id})

      assert nil_assocs(Sharings.get_sharing!(sharing.id)) == nil_assocs(sharing)
    end

    test "create_plot_sharing/2 with valid data creates a sharing" do
      user = user_fixture()
      plot = plot_fixture(user)
      user2 = user_fixture()
      valid_attrs = %{user_id: user2.id}

      assert {:ok, %Sharing{}} = Sharings.create_plot_sharing(plot, valid_attrs)
    end

    test "create_plot_sharing/2 with invalid data returns error changeset" do
      user = user_fixture()
      plot = plot_fixture(user)

      assert {:error, %Ecto.Changeset{}} = Sharings.create_plot_sharing(plot, @invalid_attrs)
    end

    test "delete_sharing/1 deletes the sharing" do
      user = user_fixture()
      plot = plot_fixture(user)
      user2 = user_fixture()
      sharing = sharing_fixture(plot, %{user_id: user2.id})

      assert {:ok, %Sharing{}} = Sharings.delete_sharing(sharing)
      assert_raise Ecto.NoResultsError, fn -> Sharings.get_sharing!(sharing.id) end
    end

    test "change_sharing/1 returns a sharing changeset" do
      user = user_fixture()
      plot = plot_fixture(user)
      user2 = user_fixture()
      sharing = sharing_fixture(plot, %{user_id: user2.id})

      assert %Ecto.Changeset{} = Sharings.change_sharing(sharing)
    end
  end

  defp nil_assocs([sharing]), do: [nil_assocs(sharing)]

  defp nil_assocs(sharing) do
    sharing
    |> Map.put(:plot, nil)
    |> Map.put(:user, nil)
  end
end
