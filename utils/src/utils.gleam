import gleam/list
import gleam/string
import simplifile

pub fn read_input() -> List(String) {
  let assert Ok(content) = simplifile.read(from: "./input.txt")

  content
  |> string.split("\n")
  |> list.filter(fn(s) { string.length(s) > 0 })
}

pub fn get_input_vertically(
  input: List(String),
  separator: String,
) -> List(List(String)) {
  input
  |> list.map(fn(line) { string.split(line, separator) })
  |> list.transpose
}

pub fn get_input_diagonally_tl_to_br(
  input: List(String),
  separator: String,
) -> List(List(String)) {
  let right_half =
    input
    |> list.index_map(fn(line, idx) {
      string.split(line, separator) |> list.drop(idx)
    })
    |> list.transpose

  let left_half =
    input
    |> list.map(fn(line) { string.split(line, separator) })
    |> list.transpose
    |> list.index_map(fn(line, idx) { line |> list.drop(idx) })
    |> list.transpose
    |> list.drop(1)

  list.flatten([right_half, left_half])
}

pub fn get_input_diagonally_bl_to_tr(
  input: List(String),
  separator: String,
) -> List(List(String)) {
  let input_reversed = list.reverse(input)

  get_input_diagonally_tl_to_br(input_reversed, separator)
}
