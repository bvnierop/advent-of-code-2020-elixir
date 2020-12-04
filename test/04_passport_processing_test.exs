defmodule AdventOfCode.Day04PassportProcessingTest do
  use ExUnit.Case
  doctest AdventOfCode.Day04PassportProcessing

  import AdventOfCode.Day04PassportProcessing

  @test_input ["ecl:gry pid:860033327 eyr:2020 hcl:#fffffd",
               "byr:1937 iyr:2017 cid:147 hgt:183cm",
               "",
               "iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884",
               "hcl:#cfa07d byr:1929",
               "",
               "hcl:#ae17e1 iyr:2013",
               "eyr:2024",
               "ecl:brn pid:760753108 byr:1931",
               "hgt:179cm",
               "",
               "hcl:#cfa07d eyr:2025 pid:166559648",
               "iyr:2011 ecl:brn hgt:59in"]
  
  test "splits chunks" do
    result = process(@test_input)
    assert Enum.count(result) == 4
  end

  test "parses each chunk" do
    first = process(@test_input)
    |> Enum.at(0)
    assert first[:cid] ==  "147"
    assert first.cid ==  "147"
  end

  test "valid" do
    card = %{:byr => "1", :iyr => "1", :eyr => "1", :hgt => "1",
             :hcl => "1", :ecl => "1", :pid => "1", :cid => "1"}
    assert valid?(card, false) == true

    no_cid_card = Map.delete(card, :cid)
    assert valid?(no_cid_card, false) == true

    invalid_card = Map.delete(card, :byr)
    assert valid?(invalid_card, false) == false

    valid_data_card = %{:byr => "1920", :iyr => "2010", :eyr => "2025", :hgt => "150cm",
                        :hcl => "#0bcdef", :ecl => "blu", :pid => "012345678", :cid => 1}
    assert valid?(valid_data_card, true) == true

    invalid_data_card = %{:byr => "1910", :iyr => "2110", :eyr => "1025", :hgt => "150in",
                        :hcl => "#abcdez", :ecl => "blk", :pid => "12345678", :cid => 1}
    assert valid?(invalid_data_card, true) == false
  end
end
