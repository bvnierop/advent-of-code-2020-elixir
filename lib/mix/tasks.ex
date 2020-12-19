defmodule Mix.Tasks.Day do
  def run(args), do: AdventOfCode.main(args)
end

defmodule Mix.Tasks.Prep do
  def run([day]), do: fetch(day)
  def run(_args), do: IO.puts("Please specify only a day.")

  defp fetch(day) do
    Application.ensure_all_started(:inets)
    Application.ensure_all_started(:ssl)
    {:ok, {{_http_ver, 200, 'OK'}, _headers, body}} =
      :httpc.request(:get, {to_charlist("https://adventofcode.com/2020/day/" <> day) , []}, [], [])

    regex = ~r/<h2>--- Day (\d+): (.+?) ---<\/h2>/
    [_, title] = Regex.run(regex, to_string(body), capture: :all_but_first)

    create_files(day, title)
  end

  defp create_files(day, title) do
    day_string = String.pad_leading(day, 2, "0")
    title_string = String.replace(title, " ", "") |> Macro.underscore
    basename = day_string <> "_" <> title_string
    module_name = "Day" <> day_string <> String.replace(title, " ", "")

    create_solution_file(basename, module_name)
    create_test_file(basename, module_name)
    create_input_files(basename, day)
  end

  defp create_solution_file(filename, module_name) do
    contents = solution_file_contents(module_name)
    create_file("lib/#{filename}.ex", contents)
  end

  defp create_file(path, contents \\ nil) do
    if File.exists?(path) do
      IO.puts("Skipping #{path}")
    else
      IO.puts("Generating #{path}")
      if contents != nil, do: File.write(path, contents), else: File.touch(path)
    end
  end

  defp solution_file_contents(module_name) do
    """
    defmodule AdventOfCode.#{module_name} do
      use AdventOfCode

      def solve_a(input) do
        Enum.at(input, 0)
      end

      def solve_b(input) do
        Enum.at(input, 0)
      end
    end
    """
  end

  defp create_test_file(filename, module_name) do
    contents = test_file_contents(module_name)
    create_file("test/#{filename}_test.exs", contents)
  end

  defp test_file_contents(module_name) do
    """
    defmodule AdventOfCode.#{module_name}Test do
      use ExUnit.Case
      doctest AdventOfCode.#{module_name}
      import AdventOfCode.#{module_name}

      test "solve", do: solve_a([])
    end
    """
  end

  defp create_input_files(filename, day) do
    case download_puzzle(2020, day) do
      {:error, :no_session_file} ->
        create_file("input/#{filename}.in")
        IO.puts "Failed to read .session file. Could not download puzzle input."
      {:error, :failed} ->
        create_file("input/#{filename}.in")
        IO.puts "Failed to download puzzle input."
      {:ok, input} -> create_file("input/#{filename}.in", input)
    end
    create_file("input/#{filename}_test.in")
  end

  defp download_puzzle(year, day) do
    Application.ensure_all_started(:inets)
    Application.ensure_all_started(:ssl)

    case File.read(".session") do
      {:error, _} -> {:error, :no_session_file}
      {:ok, session} ->
        headers = [{'cookie', String.to_charlist("session=" <> session)}]
        url = 'https://adventofcode.com/#{year}/day/#{day}/input'

        IO.puts "Fetching #{url}"

        case :httpc.request(:get, {url, headers}, [], []) do
          {:ok, {{'HTTP/1.1', 200, 'OK'}, _, puzzle}} -> {:ok, to_string(puzzle)}
          _ -> {:error, :failed}
        end
    end
  end
end
