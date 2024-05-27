defmodule Cyasg.Plots.Plot do
  use Cyasg.Schema

  alias Cyasg.Accounts.User

  schema "plots" do
    field :name, :string
    field :dataset, :string
    field :expression, :string
    field :prerendered_image, :string

    belongs_to :user, User, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(plot, attrs) do
    plot
    |> cast(attrs, [:name, :dataset, :expression, :prerendered_image])
    |> validate_required([:name, :dataset, :expression, :prerendered_image])
  end
end
