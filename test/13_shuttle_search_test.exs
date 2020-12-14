defmodule AdventOfCode.Day13ShuttleSearchTest do
  use ExUnit.Case
  doctest AdventOfCode.Day13ShuttleSearch
  import AdventOfCode.Day13ShuttleSearch

  test "closest to arrival time" do
    assert wait_time(10, 3) == 2
    assert wait_time(10, 2) == 0
  end
end
