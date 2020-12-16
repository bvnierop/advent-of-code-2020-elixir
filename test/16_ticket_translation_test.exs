defmodule AdventOfCode.Day16TicketTranslationTest do
  use ExUnit.Case
  doctest AdventOfCode.Day16TicketTranslation
  import AdventOfCode.Day16TicketTranslation

  alias AdventOfCode.Day16TicketTranslation.Parser, as: Parser

  @input """
  class: 1-3 or 5-7
  row: 6-11 or 33-44
  seat: 13-40 or 45-50

  your ticket:
  7,1,14

  nearby tickets:
  7,3,47
  40,4,50
  55,2,20
  38,6,12
  """ |> String.trim |> String.split("\n")

  test "parse" do
    assert Parser.parse(@input) == %{
      :fields => %{
        "class" => [1..3, 5..7],
        "row" => [6..11, 33..44],
        "seat" => [13..40, 45..50]
      },
      :ticket => {7, 1, 14},
      :nearby => [{7,3,47}, {40,4,50}, {55,2,20}, {38,6,12}],
    }
  end

  test "really simply validation" do
    data = Parser.parse(@input)
    assert invalid_values({7, 3, 47, 40, 4, 50, 55, 2, 20, 38, 6, 12}, data.fields) == [4, 55, 12]
  end

  test "solve a" do
    assert solve_a(@input) == 71
  end

  # index of class == 1
  # index of row == 0
  # index of seat == 2
  # last ticket is invalid
  @input_for_id """
  class: 0-1 or 4-19
  departure row: 0-5 or 8-19
  departure seat: 0-13 or 16-19

  your ticket:
  11,12,13

  nearby tickets:
  3,9,18
  15,1,5
  5,14,9
  11,12,20
  """ |> String.trim |> String.split("\n")

  test "validate ticket" do
    data = Parser.parse(@input_for_id)
    assert valid?({11,12,20}, data.fields) == false
    assert valid?({11,12,13}, data.fields) == true

    assert valid_tickets(data) == [{3,9,18}, {15,1,5}, {5,14,9}]
  end

  test "identify fields" do
    data = Parser.parse(@input_for_id)
    assert id_fields([data.ticket | valid_tickets(data)], data.fields) == %{"class" => 1, "departure row" => 0, "departure seat" => 2}
  end

  test "solve b" do
    assert solve_b(@input_for_id) == 11 * 13
  end
end
