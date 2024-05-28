defmodule Cyasg.SharingsTest do
  use Cyasg.DataCase

  alias Cyasg.Sharings

  describe "sharings" do
    alias Cyasg.Sharings.Sharing

    import Cyasg.SharingsFixtures

    @invalid_attrs %{}

    test "list_sharings/0 returns all sharings" do
      sharing = sharing_fixture()
      assert Sharings.list_sharings() == [sharing]
    end

    test "get_sharing!/1 returns the sharing with given id" do
      sharing = sharing_fixture()
      assert Sharings.get_sharing!(sharing.id) == sharing
    end

    test "create_sharing/1 with valid data creates a sharing" do
      valid_attrs = %{}

      assert {:ok, %Sharing{} = sharing} = Sharings.create_sharing(valid_attrs)
    end

    test "create_sharing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sharings.create_sharing(@invalid_attrs)
    end

    test "update_sharing/2 with valid data updates the sharing" do
      sharing = sharing_fixture()
      update_attrs = %{}

      assert {:ok, %Sharing{} = sharing} = Sharings.update_sharing(sharing, update_attrs)
    end

    test "update_sharing/2 with invalid data returns error changeset" do
      sharing = sharing_fixture()
      assert {:error, %Ecto.Changeset{}} = Sharings.update_sharing(sharing, @invalid_attrs)
      assert sharing == Sharings.get_sharing!(sharing.id)
    end

    test "delete_sharing/1 deletes the sharing" do
      sharing = sharing_fixture()
      assert {:ok, %Sharing{}} = Sharings.delete_sharing(sharing)
      assert_raise Ecto.NoResultsError, fn -> Sharings.get_sharing!(sharing.id) end
    end

    test "change_sharing/1 returns a sharing changeset" do
      sharing = sharing_fixture()
      assert %Ecto.Changeset{} = Sharings.change_sharing(sharing)
    end
  end
end
