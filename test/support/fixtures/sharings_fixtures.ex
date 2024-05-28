defmodule Cyasg.SharingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cyasg.Sharings` context.
  """

  @doc """
  Generate a sharing.
  """
  def sharing_fixture(attrs \\ %{}) do
    {:ok, sharing} =
      attrs
      |> Enum.into(%{

      })
      |> Cyasg.Sharings.create_sharing()

    sharing
  end
end
