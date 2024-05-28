defmodule Cyasg.Sharings.Sharing do
  use Cyasg.Schema

  alias Cyasg.Accounts.User
  alias Cyasg.Plots.Plot

  schema "sharings" do
    belongs_to :user, User, type: :binary_id
    belongs_to :plot, Plot, type: :binary_id

    timestamps(updated_at: false, type: :utc_datetime)
  end

  @doc false
  def changeset(sharing, attrs) do
    sharing
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
  end
end
