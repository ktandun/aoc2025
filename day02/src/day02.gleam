import gleam/int
import gleam/list
import gleam/regexp
import gleam/result
import gleam/string
import utils

pub type Instruction {
  Instruction(start: Int, end: Int)
}

pub fn main() {
  let day_input = utils.read_input()
  echo part_one(day_input)
  echo part_two(day_input)
}

pub fn part_one(input: List(String)) {
  input
  |> line_to_instruction
  |> list.map(apply_instruction)
  |> list.flatten
  |> int.sum
}

pub fn part_two(input: List(String)) {
  input
  |> line_to_instruction
  |> list.map(apply_instruction2)
  |> list.flatten
  |> int.sum
}

fn line_to_instruction(input: List(String)) {
  input
  |> list.map(fn(x) { string.split(x, ",") })
  |> list.flatten
  |> list.filter(fn(x) { !string.is_empty(x) })
  |> list.map(fn(x) {
    let start =
      x
      |> string.split("-")
      |> list.first
      |> result.unwrap("")
      |> int.parse
      |> result.unwrap(0)

    let end =
      x
      |> string.split("-")
      |> list.last
      |> result.unwrap("")
      |> int.parse
      |> result.unwrap(0)

    Instruction(start, end)
  })
}

fn apply_instruction(instruction: Instruction) {
  list.range(instruction.start, instruction.end)
  |> list.filter(is_invalid_id)
}

fn apply_instruction2(instruction: Instruction) {
  list.range(instruction.start, instruction.end)
  |> list.filter(is_invalid_id2)
}

fn is_invalid_id(id: Int) {
  let id_string = int.to_string(id)
  let string_length = string.length(id_string)

  let start = id_string |> string.drop_start(string_length / 2)
  let end = id_string |> string.drop_end(string_length / 2)

  string_length % 2 == 0 && start == end
}

fn is_invalid_id2(id: Int) {
  let id_string = int.to_string(id)
  let string_length = string.length(id_string)

  list.range(1, string_length - 1)
  |> list.map(fn(x) { string.drop_end(id_string, x) })
  |> list.any(fn(substring) {
    is_substring_repeatable(id_string, string_length, substring)
  })
}

fn is_substring_repeatable(
  id_string: String,
  string_length: Int,
  substring: String,
) -> Bool {
  let assert Ok(re) = regexp.from_string(substring)
  let matches = regexp.scan(re, id_string)
  let matches_count = list.length(matches)
  matches_count >= 2
  && matches_count * string.length(substring) == string_length
}
