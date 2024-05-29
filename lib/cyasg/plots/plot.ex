defmodule Cyasg.Plots.Plot do
  use Cyasg.Schema

  alias Cyasg.Datasets
  alias Cyasg.Expressions
  alias Cyasg.Accounts.User

  schema "plots" do
    field :name, :string
    field :dataset, :string
    field :expression, :string

    field :columns, {:array, :string}, virtual: true
    field :datapoints, {:array, :decimal}, default: []

    belongs_to :user, User, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(plot, datapoints, attrs) do
    plot
    |> cast(attrs, [:name, :dataset, :expression])
    |> put_change(:datapoints, datapoints)
    |> validate_required([:name, :dataset, :expression])
    |> preload_columns()
    |> validate_expression()
  end

  defp preload_columns(changeset) do
    dataset = get_field(changeset, :dataset)
    put_change(changeset, :columns, Datasets.columns(dataset))
  end

  defp validate_expression(changeset) do
    expression = get_field(changeset, :expression)

    if is_nil(expression) do
      changeset
    else
      columns = get_field(changeset, :columns)

      errors =
        case Expressions.parse(expression, columns) do
          {:ok, _tags} -> []
          {:error, messages} -> messages
        end

      Enum.reduce(errors, changeset, fn error, changeset ->
        add_error(changeset, :expression, error)
      end)
    end
  end
end
