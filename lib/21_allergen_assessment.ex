defmodule AdventOfCode.Day21AllergenAssessment do
  use AdventOfCode

  @doc """
  Parse the problem input to a list of meals, where each meal is a tuple
  containing a list of ingredients and a list of allergens.

  ## Example
  
      iex> parse(["apple milk salmon (contains dairy, fish)", "lemon (contains sour)"])
      [{["apple", "milk", "salmon"], ["dairy", "fish"]}, {["lemon"], ["sour"]}]
  """
  def parse(input) do
    Enum.map(input, fn line ->
      [ingredients, allergens] =
        Regex.run(~r/(.+?) \(contains (.+)\)/, line, capture: :all_but_first)
      {String.split(ingredients," "), String.split(allergens, ", ")}
    end)
  end

  @doc """
  Basic solution idea for part one:
    For each allergen
      For each ingredient in any meal with that allergen
        If it's in all meals, it can have that allergen

  In order to do that, we need:
  a) for each allergen, a list of meals
       quick lookup of ingredient in a meal, so a meal should probably be a mapset of ingredients

  From there, we can simply take a list of all ingredients and remove from that list
  any ingredient that can have an allergen.

  Finally, we need to go over every meal and see how often these ingredients occur.

  ## Example
  
    iex> solve_a(["mxmxvkd kfcds sqjhc nhms (contains dairy, fish)",
    ...> "trh fvjkl sbzzf mxmxvkd (contains dairy)",
    ...> "sqjhc fvjkl (contains soy)",
    ...> "sqjhc mxmxvkd sbzzf (contains fish)"])
    5
  """
  def solve_a(input) do
    cookbook = parse(input)
    all_ingredients = ingredients(cookbook, duplicates: false)
    with_allergens = ingredients_with_possible_allergens(cookbook)
    |> Enum.flat_map(fn {_allergen, possible_ingredients} -> possible_ingredients end)
    |> MapSet.new

    ingredients_without_allergens = MapSet.difference(all_ingredients, with_allergens)
    all_ingredients_with_duplicates = ingredients(cookbook, duplicates: true)
    ingredient_counts = Enum.reduce(all_ingredients_with_duplicates, %{},
      fn ingredient, counts -> Map.put(counts, ingredient, (counts[ingredient] || 0) + 1) end)

    Enum.map(ingredients_without_allergens, fn ingredient ->
      ingredient_counts[ingredient]
    end)
    |> Enum.sum
  end

  @doc """
  Returns an enumeration of all ingredients in a cookbook. With option to eliminate duplicates.
 
  ## Examples

      iex> ingredients([{["apple", "milk", "salmon"], []}, {["apple"], []}], duplicates: false)
      MapSet.new(["apple", "milk", "salmon"])

      iex> ingredients([{["apple", "milk", "salmon"], []}, {["apple"], []}], duplicates: true)
      ["apple", "milk", "salmon", "apple"]
  """
  def ingredients(cookbook, duplicates: dupes) do
    all_ingredients = cookbook
    |> Enum.flat_map(fn {ingredients, _allergens} -> ingredients end)
    if dupes, do: all_ingredients, else: MapSet.new(all_ingredients)
  end

  @doc """
  Returns a lookup with a list of meals per allergen. In order to allow for quick
  ingredient checking, the meals are represent as MapSet, not as List.

  ## Example

      iex> meals_with_allergens([{["apple", "milk", "salmon"], ["dairy", "fish"]}, {["lemon"], ["sour"]}])
      %{"dairy" => [MapSet.new(["apple", "milk", "salmon"])],
        "fish" => [MapSet.new(["apple", "milk", "salmon"])],
        "sour" => [MapSet.new(["lemon"])]}
  """
  def meals_with_allergens(cookbook) do
    cookbook
    |> Enum.reduce(%{}, fn {ingredients, allergens}, lookup ->
      allergens
      |> Enum.reduce(lookup, fn allergen, lookup ->
        Map.put(lookup, allergen, [MapSet.new(ingredients) | (lookup[allergen] || [])])
      end)
    end)
  end

  @doc """
  Returns a list of ingredients, grouped by allergen, that may contain that allergen.
  An ingredient may contain an allergen if and only if it's present in all meals that
  contain said allergen.

  ## Example
  
    iex> ingredients_with_possible_allergens([
    ...> {["mxmxvkd", "kfcds", "sqjhc", "nhms"], ["dairy", "fish"]},
    ...> {["trh", "fvjkl", "sbzzf", "mxmxvkd"], ["dairy"]},
    ...> {["sqjhc", "fvjkl"], ["soy"]},
    ...> {["sqjhc", "mxmxvkd", "sbzzf"], ["fish"]}])
    %{"dairy" => ["mxmxvkd"],
      "fish" => ["mxmxvkd", "sqjhc"],
      "soy" => ["fvjkl", "sqjhc"]} 
  """
  def ingredients_with_possible_allergens(cookbook) do
    lookup = meals_with_allergens(cookbook)
    Enum.reduce(lookup, %{}, fn {allergen, meals}, possibilities ->
      all_ingredients = Enum.flat_map(meals, fn meal -> meal end) |> MapSet.new
      possible_ingredients = all_ingredients
      |> Enum.filter(fn ingredient ->
        Enum.all?(meals, &MapSet.member?(&1, ingredient))
      end)
      Map.put(possibilities, allergen, possible_ingredients)
    end)
  end

  @doc """
  For part two we can assume there is only one solution. Because of that, we can constantly
  look at the next allergy for which we have but one choice, and then take that choice.
  Of course, after taking the choice, we should update the remaining allergies by removing
  that option.

  We start by taking the list of ingredients with possible allergens and then walking
  it, constantly taking the next one.

  Once we've got the results by allergen, take the allergens, sort them, and output
  the result.

  Unfortunately, we cannot rely on the ordering of maps. At larger sizes, they are
  implemented with hashing.

  ## Example
    iex> solve_b(["mxmxvkd kfcds sqjhc nhms (contains dairy, fish)",
    ...> "trh fvjkl sbzzf mxmxvkd (contains dairy)",
    ...> "sqjhc fvjkl (contains soy)",
    ...> "sqjhc mxmxvkd sbzzf (contains fish)"])
    "mxmxvkd,sqjhc,fvjkl"

  """
  def solve_b(input) do
    dangerous_ingredients = input
    |> parse
    |> dangerous_ingredients

    dangerous_ingredients
    |> Map.keys
    |> Enum.sort
    |> Enum.map(&(dangerous_ingredients[&1]))
    |> Enum.join(",")
  end

  @doc """
  Returns a mapping of allergens and the ingredient that contains each one.

  ## Examples
    iex> dangerous_ingredients([{["apple"], ["fruit"]}]) 
    %{"fruit" => "apple"}


    iex> dangerous_ingredients([
    ...> {["mxmxvkd", "kfcds", "sqjhc", "nhms"], ["dairy", "fish"]},
    ...> {["trh", "fvjkl", "sbzzf", "mxmxvkd"], ["dairy"]},
    ...> {["sqjhc", "fvjkl"], ["soy"]},
    ...> {["sqjhc", "mxmxvkd", "sbzzf"], ["fish"]}])
    %{"dairy" => "mxmxvkd",
      "fish" => "sqjhc",
      "soy" => "fvjkl"}
  """
  def dangerous_ingredients(cookbook) do
    reduce_allergens(ingredients_with_possible_allergens(cookbook))
  end

  defp reduce_allergens(_, _accumulator \\ %{})
  defp reduce_allergens(ing, acc) when ing == %{}, do: acc
  defp reduce_allergens(ingredients_with_possible_allergens, accumulator) do
    # Pick the next allergen
    {allergen, [ingredient]} = Enum.min_by(ingredients_with_possible_allergens,
      fn {_allergen, ingredients} -> Enum.count(ingredients) end)

    # Add the answer
    acc = Map.put(accumulator, allergen, ingredient)

    # Update the collection
    updated_allergen_map = for {a, ingredients} <- ingredients_with_possible_allergens,
    a != allergen,
    into: %{} do
        i = Enum.reject(ingredients, &(&1 == ingredient))
        {a, i}
    end

    # Return
    reduce_allergens(updated_allergen_map, acc)
  end
end
