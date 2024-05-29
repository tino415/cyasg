defmodule Cyasg.Datasets do
  alias Cyasg.Expressions
  alias NimbleCSV.RFC4180, as: CSV

  require Logger

  def list() do
    File.read!("#{File.cwd!()}/datasets.json")
    |> Jason.decode!()
    |> Map.keys()
  end

  def columns(name) do
    File.read!("#{File.cwd!()}/datasets.json")
    |> Jason.decode!()
    |> Map.get(name, [])
  end

  def column(dataset_name, expression) do
    dataset_url = url(dataset_name)
    request = Finch.build(:get, dataset_url)
    {:ok, result} = Finch.request(request, Cyasg.Finch)
    [columns | rows] = CSV.parse_string(result.body, skip_headers: false)

    Enum.map(rows, &Expressions.evaluate!(expression, columns, &1))
  rescue
    error ->
      Logger.error("Unable to evaluate datapoints #{inspect(error)}")
      []
  end

  def url(dataset_name),
    do: "https://raw.githubusercontent.com/plotly/datasets/master/#{dataset_name}.csv"

  def generate_index() do
    index =
      Path.wildcard("#{File.cwd!()}/datasets/**/*.csv")
      |> Enum.reduce(%{}, fn file_path, index ->
        try do
          name =
            file_path
            |> String.replace_prefix("#{File.cwd!()}/datasets/", "")
            |> String.replace_suffix(".csv", "")

          columns =
            File.stream!(file_path)
            |> CSV.parse_stream(skip_headers: false)
            |> Enum.take(1)
            |> List.first()

          # some csv are wrongly formatted, end up putting all rows in
          # to the index
          if byte_size(:erlang.term_to_binary(columns)) > 1000 do
            index
          else
            Map.put(index, name, columns)
          end
        rescue
          _ -> index
        end
      end)

    File.write!("#{File.cwd!()}/datasets.json", Jason.encode!(index))
  end
end
