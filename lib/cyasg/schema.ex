defmodule Cyasg.Schema do
  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset

      @primary_key {:id, :binary_id, autogenerate: true}
      @derive {Phoenix.Param, key: :id}
    end
  end
end
