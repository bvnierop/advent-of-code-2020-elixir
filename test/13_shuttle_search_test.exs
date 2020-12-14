defmodule AdventOfCode.Day13ShuttleSearchTest do
  use ExUnit.Case
  doctest AdventOfCode.Day13ShuttleSearch
  import AdventOfCode.Day13ShuttleSearch

  test "closest to arrival time" do
    assert wait_time(10, 3) == 2
    assert wait_time(10, 2) == 0
  end

  test "chinese remainder theorem" do
    assert crt([{3, 2}, {5, 3}, {7, 2}]) == 23
    assert crt([{13, 0}, {7, 1}]) == 78
    assert crt([{19, 0}, {31, 1}, {1, 2}, {59, 3}, {13, 6}, {7, 7}]) == 1068788
  end

  test "modular inverse" do
    assert mi(2017, 42) == 1969
  end

  test "b" do
    assert solve_b(["", "7,13,x,x,59,x,31,19"]) == 1068781
    assert solve_b(["", "67,x,7,59,61"]) == 779210
  end
end
