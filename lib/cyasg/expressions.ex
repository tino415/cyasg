defmodule Cyasg.Expressions do
  alias Cyasg.Expressions.Parser

  def parse(expression, columns) do
    with {:ok, tags, "", _, _, _} <- Parser.expression(expression),
         [] <- check_semantics(tags, columns) do
      {:ok, tags}
    else
      {:ok, _tags, _rest, _, _, _} ->
        {:error, ["Incomplete expression"]}

      {:error, message, _, _, _, _} ->
        {:error, [message]}

      messages ->
        {:error, messages}
    end
  end

  def evaluate!(expression, columns, row) do
    case parse(expression, columns) do
      {:ok, tags} ->
        {result, _operator} =
          Enum.reduce(tags, {Decimal.new(0), "+"}, fn
            {:column, [column]}, {sum, "+" = o} ->
              {Decimal.add(sum, get_column_value!(column, columns, row)), o}

            {:column, [column]}, {sum, "-" = o} ->
              {Decimal.sub(sum, get_column_value!(column, columns, row)), o}

            {:column, [column]}, {sum, "*" = o} ->
              {Decimal.mult(sum, get_column_value!(column, columns, row)), o}

            {:column, [column]}, {sum, "/" = o} ->
              {Decimal.div(sum, get_column_value!(column, columns, row)), o}

            {:operator, [operator]}, {sum, _} ->
              {sum, operator}
          end)

        result

      {:error, messages} ->
        raise "Unable to evaluate #{inspect(messages)}"
    end
  end

  defp get_column_value!(column, columns, row) do
    case Enum.find_index(columns, &(&1 == column)) do
      nil ->
        raise "Unknown column #{column}"

      # TODO: use Decimal for rounding errors
      index ->
        value = get_in(row, [Access.at(index)])
        Decimal.new(value)
    end
  end

  defp check_semantics(tags, columns) do
    Enum.reduce(tags, [], &check_tag_semantics(columns, &1, &2))
  end

  defp check_tag_semantics(columns, {:column, [name]}, errors) do
    if name in columns do
      errors
    else
      ["Unknown column #{name}" | errors]
    end
  end

  defp check_tag_semantics(_columns, _tag, errors), do: errors
end
