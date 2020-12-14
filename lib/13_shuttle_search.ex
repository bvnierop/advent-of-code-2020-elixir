defmodule AdventOfCode.Day13ShuttleSearch do
  use AdventOfCode

  def solve_a(input) do
    {arrival, busses} = input |> parse

    {bus, wait_time} = busses
    |> Enum.map(fn bus -> {bus, wait_time(arrival, bus)} end)
    |> Enum.min_by(fn {_bus, wait} -> wait end)

    {bus, wait_time, bus * wait_time}
  end

  def solve_b(input) do
    Enum.at(input, 0)
  end

  def parse([arrival, busses]) do
    {String.to_integer(arrival), parse_busses(busses)}
  end

  def parse_busses(busses) do
    busses
    |> String.split(",")
    |> Enum.reject(&(&1 == "x"))
    |> Enum.map(&String.to_integer/1)
  end

  def wait_time(arrival, bus_interval) do
    minutes_too_early = rem(arrival, bus_interval)
    if minutes_too_early == 0, do: 0, else: bus_interval - minutes_too_early
  end
end
