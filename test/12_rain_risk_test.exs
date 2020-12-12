defmodule AdventOfCode.Day12RainRiskTest do
  use ExUnit.Case
  doctest AdventOfCode.Day12RainRisk
  import AdventOfCode.Day12RainRisk

  test "rotate" do
    assert rotate({0, -10}, 90) == { 10,   0}
    assert rotate({10, 0}, 90) ==  {  0,  10}
    assert rotate({0, 10}, 90) ==  {-10,   0}
    assert rotate({-10, 0}, 90) == {  0, -10}

    assert rotate({-10, 0}, 180) == {10, 0}
    assert rotate({-10, 0}, 270) == {0, 10}

    assert rotate({-10, 0}, -90) == {0, 10}
  end
end
