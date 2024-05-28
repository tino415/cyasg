defmodule Cyasg.SharingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cyasg.Sharings` context.
  """

  @doc """
  Generate a sharing.
  """
  def sharing_fixture(plot, attrs \\ %{}) do
    attrs = Enum.into(attrs, %{})

    {:ok, sharing} = Cyasg.Sharings.create_plot_sharing(plot, attrs)

    sharing
  end
end
