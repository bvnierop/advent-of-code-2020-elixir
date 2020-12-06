defmodule AdventOfCode.Day06CustomCustoms do
  use AdventOfCode

  def solve_a(input) do
    input
    |> group
    |> Enum.map(&concat/1)
    |> Enum.map(&count_different_answers/1)
    |> Enum.sum
  end

  defp group(input) do
    input
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.reject(&(&1 == [""]))
  end

  defp concat(answer_group) do
    answer_group
    |> Enum.join("")
    |> String.graphemes
  end

  defp count_different_answers(answers), do: MapSet.new(answers) |> MapSet.size

  def solve_b(input) do
    input
    |> group
    |> Enum.map(fn g -> {Enum.count(g), concat(g)} end)
    |> Enum.map(fn {group_size, g} -> {group_size, count_answers(g)} end)
    |> Enum.map(&count_answered_by_everyone/1)
    |> Enum.sum
  end

  defp count_answers(group) do
    Enum.reduce(group, %{}, fn answer, counts ->
      Map.put(counts, answer, (counts[answer] || 0) + 1)
    end)
  end

  defp count_answered_by_everyone({group_size, counts}) do
    Enum.count(counts, fn {_answer, count} ->
      count == group_size
    end)
  end
end
