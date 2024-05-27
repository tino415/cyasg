defmodule Cyasg.Plots.Plot do
  use Cyasg.Schema

  alias Cyasg.Accounts.User

  schema "plots" do
    field :name, :string
    field :dataset, :string
    field :expression, :string

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(plot, attrs) do
    plot
    |> cast(attrs, [:name, :dataset, :expression])
    |> validate_required([:name, :dataset, :expression])
  end
end
