import gleam/int
import gleam/list
import gleam/result
import gleam/string
import utils

pub type Instruction {
  Instruction(direction: String, amount: Int)
}

pub fn main() {
  let day_input = utils.read_input()

  echo part_one(day_input)
  echo part_two(day_input)
}

pub fn part_one(input: List(String)) {
  let instructions =
    input
    |> list.map(line_to_instruction)

  let initial_state = 50

  list.fold(instructions, #(initial_state, 0), fn(acc, instruction) {
    let #(current_state, score) = acc
    let new_state = apply_instruction(current_state, instruction)
    let new_score = case new_state % 100 == 0 {
      False -> score
      True -> score + 1
    }

    #(new_state, new_score)
  })
}

pub fn part_two(input: List(String)) {
  let instructions =
    input
    |> list.map(line_to_instruction)

  let initial_state = 50

  list.fold(instructions, #(initial_state, 0), fn(acc, instruction) {
    let #(current_state, score) = acc
    let #(new_state, num_passing_zero) =
      apply_instruction2(current_state, instruction)
    let new_score = case new_state % 100 == 0 {
      False -> score
      True -> score + 1
    }

    #(new_state, new_score + num_passing_zero)
  })
}

fn line_to_instruction(input: String) {
  let direction = input |> string.first |> result.unwrap("")
  let amount =
    input
    |> string.slice(at_index: 1, length: string.length(input) - 1)
    |> int.parse
    |> result.unwrap(0)

  Instruction(direction: direction, amount: amount)
}

fn apply_instruction(current_state: Int, instruction: Instruction) {
  let new_state = case instruction.direction {
    "L" -> current_state - instruction.amount
    "R" -> current_state + instruction.amount
    _ -> todo
  }

  new_state
}

fn apply_instruction2(current_state: Int, instruction: Instruction) {
  let new_state = case instruction.direction {
    "L" -> current_state - instruction.amount
    "R" -> current_state + instruction.amount
    _ -> todo
  }

  #(new_state, count_passing_zero(current_state, new_state))
}

fn count_passing_zero(prev_state: Int, new_state: Int) {
  list.range(prev_state, new_state)
  |> list.drop(1)
  |> list.reverse()
  |> list.drop(1)
  |> list.reverse()
  |> list.count(fn(x) { x % 100 == 0 })
}
