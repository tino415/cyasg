defmodule Cyasg.Datasets do
  alias NimbleCSV.RFC4180, as: CSV

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

  def column(dataset_name, column_name) do
    stream =
      dataset_name
      |> path()
      |> File.stream!()
      |> CSV.parse_stream(skip_headers: false)

    index =
      stream
      |> Enum.take(1)
      |> List.first()
      |> Enum.find_index(&(&1 == column_name))

    Stream.map(stream, &get_in(&1, [Access.at(index)]))
  end

  def path(dataset_name), do: "#{File.cwd!()}/datasets/#{dataset_name}.csv"
end
