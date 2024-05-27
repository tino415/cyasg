defmodule Cyasg.Context do
  defmacro __using__(_opts) do
    quote do
        import Ecto.Query, warn: false

        alias Cyasg.Repo
    end
  end
end
