import gleam/int
import gleam/list
import gleam/order
import gleam/regexp
import gleam/result
import gleam/string
import utils

pub type Instruction {
  Instruction(data: String, data_int: Int)
}

pub fn main() {
  let day_input = utils.read_input()
  echo part_one(day_input)
  echo part_two(day_input)
}

pub fn part_one(input: List(String)) {
  input
  |> line_to_instruction
  |> list.map(apply_instruction1)
  |> int.sum
}

pub fn part_two(input: List(String)) {
  input
  |> line_to_instruction
  |> list.map(apply_instruction2)
  |> int.sum
}

fn line_to_instruction(input: List(String)) {
  input
  |> list.filter(fn(x) { !string.is_empty(x) })
  |> list.map(fn(x) {
    Instruction(
      data: x,
      data_int: int.parse(x)
        |> result.unwrap(0),
    )
  })
}

fn apply_instruction1(instruction: Instruction) {
  let regexes = create_regexes()
  find_largest_2_numbers(instruction, regexes)
}

fn create_regexes() {
  list.range(9, 1)
  |> list.map(fn(i) {
    list.range(9, 1)
    |> list.map(fn(j) {
      #(i * 10 + j, string.join([int.to_string(i), int.to_string(j)], ".*"))
    })
  })
  |> list.flatten
  |> list.map(fn(tuple) {
    let #(num, regex_string) = tuple
    let assert Ok(re) =
      regexp.compile(
        regex_string,
        regexp.Options(case_insensitive: False, multi_line: False),
      )

    #(num, re)
  })
}

fn find_largest_2_numbers(
  instruction: Instruction,
  regexes: List(#(Int, regexp.Regexp)),
) {
  regexes
  |> list.filter_map(fn(x) {
    let #(num, reg) = x
    case regexp.check(reg, instruction.data) {
      False -> Error("")
      True -> Ok(num)
    }
  })
  |> list.first
  |> result.unwrap(0)
}

pub fn apply_instruction2(instruction: Instruction) {
  let #(_, result) =
    list.range(12, 1)
    |> list.fold(#(-1, 0), fn(acc, i) {
      let #(idx, curr) = acc
      let #(idx_highest, highest) =
        sort_numbers_by_value_and_get_index(instruction.data, idx, i)

      #(idx_highest, curr * 10 + highest)
    })

  result
}

fn sort_numbers_by_value_and_get_index(
  data: String,
  index_start: Int,
  letters_remaining: Int,
) {
  let str_len = string.length(data)
  string.to_graphemes(data)
  |> list.index_map(fn(x, i) {
    #(
      i,
      int.parse(x)
        |> result.unwrap(0),
    )
  })
  |> list.filter(fn(x) {
    let #(i, _) = x

    i > index_start && i + letters_remaining <= str_len
  })
  |> list.sort(fn(x, y) {
    let #(first_idx, first) = x
    let #(second_idx, second) = y
    case int.compare(second, first) {
      order.Eq -> int.compare(first_idx, second_idx)
      order.Gt -> order.Gt
      order.Lt -> order.Lt
    }
  })
  |> list.first()
  |> result.unwrap(#(0, 0))
}
