defmodule AdventOfCode.Day22CrabCombat do
  use AdventOfCode

  @doc """
  Parses the input into a tuple of two lists: the deck for player 1 and the deck for player 2.

  ## Example
    iex> parse(["Player 1:", "9", "2", "", "Player 2:", "5", "8"])
    {[9, 2], [5, 8]}
  """
  def parse(input) do
    input
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.reject(&(&1 == [""]))
    |> Enum.map(fn [_player | deck] -> Enum.map(deck, &String.to_integer/1) end)
    |> List.to_tuple
  end

  @doc """
  Start a game given two decks. Returns two queues of decks.

  ## Example
    iex> start {[9, 2], [5, 8]}
    {:queue.from_list([9, 2]), :queue.from_list([5, 8])}
  """
  def start({deck_a, deck_b}) do
    {:queue.from_list(deck_a), :queue.from_list(deck_b)}
  end

  @doc """
  Executes a turn and returns a tuple containing the new decks, the played cards and the id of the player
  who won the hand.

  Performing a turn with at least one empty deck returns a winner

  ## Examples
    iex> turn(start({[9, 2], [8, 5]}))
    {:turn, {:queue.from_list([2, 9, 8]), :queue.drop(:queue.from_list([8, 5]))}, {9, 8}, 1}

    iex> turn(start({[9, 2], []}))
    {:winner, [9, 2], 1}
  """
  def turn({deck_a, deck_b}) do
    turn_result = with {{:value, a}, qa} <- :queue.out(deck_a),
         {{:value, b}, qb} <- :queue.out(deck_b) do
      if a > b do
        {:turn, {:queue.join(qa, :queue.from_list([a, b])), qb}, {a, b}, 1}
      else
        {:turn, {qa, :queue.join(qb, :queue.from_list([b, a]))}, {a, b}, 1}
      end
    end

    case turn_result do
      {:empty, _} -> if :queue.len(deck_a) == 0, do: {:winner, :queue.to_list(deck_b), 2}, else: {:winner, :queue.to_list(deck_a), 1}
      _ -> turn_result
    end
  end

  @doc """
  Scores a deck of cards.

  ## Example
    iex> score([9, 2])
    2 * 1 + 9 * 2
  """
  def score(deck) do
    deck
    |> Enum.reverse
    |> Enum.with_index(1)
    |> Enum.map(fn {val, index} -> val * index end)
    |> Enum.sum
  end


  @doc """
  Turns a game of combat into a stream.

  ## Examples
    iex> stream({[9, 2], [8, 5]}) |> Enum.at(0)
    turn(start({[9, 2], [8, 5]}))

    iex> stream({[9, 2], [8, 5]}) |> Enum.at(4)
    {:winner, [9, 5, 8, 2], 1}

    iex> stream({[9, 2], [8, 5]}) |> Enum.at(5)
    nil
  """
  def stream(decks) do
    Stream.unfold(turn(start(decks)), fn
      nil -> nil
      {:winner, _winning_deck, _winner} = step -> {step, nil}
      {:turn, decks, _cards, _winner} = step -> {step, turn(decks)}
      end)
  end

  @doc """
  Return the score of the winning player after playing the game.
  
  ## Example
    iex> solve_a(["Player 1:", "9", "2", "6", "3", "1",
    ...> "",
    ...> "Player 2:", "5", "8", "4", "7", "10"])
    306
  """
  def solve_a(input) do
    {:winner, winning_deck, _winner} = input
    |> parse
    |> stream
    |> Enum.at(-1)

    score(winning_deck)
  end

  def solve_b(input) do
    Enum.at(input, 0)
  end
end
