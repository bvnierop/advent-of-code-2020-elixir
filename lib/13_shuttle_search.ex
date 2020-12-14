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
    [_, bus_line] = input

    busses = bus_line
    |> String.replace("x", "1")
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)

    last_departure_at = busses
    |> Enum.reverse
    |> Enum.with_index
    |> crt

    last_departure_at - Enum.count(busses) + 1
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

  # Chinese Remainder Theorem shamelessly stolen from Rosetta Code (F# implementation)
  def crt(seq) do
    fN = Enum.reduce(seq, 1, fn {n, _a}, acc -> n * acc end)
    part = Enum.reduce(seq, 0, fn {n, a}, res ->
      res + a * div(fN, n) * mi(n, Integer.mod(div(fN, n), n))
    end)
    Integer.mod(part, fN)
  end

  # Modular Inverse shamelessly stolen from Rosetta Code (F# implementation)
  def mi(n, g) do
    Integer.mod(n + mi_rec(n, 1, 0, g, 0, 1), n)
  end

  defp mi_rec(n, i, g, e, l, a) do
    case e do
      0 -> g
      _ ->
        o = div(n, e)
        mi_rec(e, l, a, (n - o * e), (i - o * l), (g - o * a))
    end
  end
end
