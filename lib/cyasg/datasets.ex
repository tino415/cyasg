defmodule Cyasg.Datasets do
  alias Cyasg.Expressions
  alias NimbleCSV.RFC4180, as: CSV

  require Logger

  @filenames Path.wildcard("#{File.cwd!()}/datasets/**/*.csv")
             |> Enum.map(&String.replace_prefix(&1, "#{File.cwd!()}/datasets/", ""))
             |> Enum.map(&String.replace_suffix(&1, ".csv", ""))

  def list(), do: @filenames

  def columns(dataset_name) do
    dataset_name
    |> path()
    |> File.stream!()
    |> CSV.parse_stream(skip_headers: false)
    |> Enum.take(1)
    |> List.first()
  end

  def column(dataset_name, expression) do
    stream =
      dataset_name
      |> path()
      |> File.stream!()
      |> CSV.parse_stream(skip_headers: false)

    columns =
      stream
      |> Enum.take(1)
      |> List.first()

    stream
    |> Stream.drop(1)
    |> Stream.map(&Expressions.evaluate!(expression, columns, &1))
    # eager evaluation = simpler debugging
    |> Enum.into([])
  rescue
    error ->
      Logger.error("Unable to evaluate datapoints #{inspect(error)}")
      []
  end

  def path(dataset_name), do: "#{File.cwd!()}/datasets/#{dataset_name}.csv"
end
