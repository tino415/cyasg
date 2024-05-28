defmodule Cyasg.Expressions.Parser do
  import NimbleParsec

  defparsec(
    :expression,
    repeat(ignore(string(" ")))
    |> ignore(string("'"))
    |> concat(utf8_string([not: ?'], min: 1))
    |> ignore(string("'"))
    |> tag(:column)
    |> repeat(
      repeat(ignore(string(" ")))
      |> tag(
        choice([
          string("+"),
          string("-"),
          string("*"),
          string("/")
        ]),
        :operator
      )
      |> repeat(ignore(string(" ")))
      |> tag(
        ignore(string("'"))
        |> concat(utf8_string([not: ?'], min: 1))
        |> ignore(string("'")),
        :column
      )
    )
  )
end
