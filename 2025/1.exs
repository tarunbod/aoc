defmodule Day1 do
  def parse_spin(instruction) do
    direction =
      case String.at(instruction, 0) do
        "L" -> -1
        "R" -> 1
      end

    count = String.slice(instruction, 1..-1//1) |> Integer.parse() |> elem(0)
    direction * count
  end

  def process(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_spin/1)
    |> Enum.scan({50, 0}, fn s, {a, b} ->
      next = Integer.mod(a + s, 100)
      c = floor(abs(a + s) / 100.0)
      c = c + (if a != 0 and s < 0 and a <= abs(s) do 1 else 0 end)
      {next, c}
    end)
  end

  def run do
    {_, input} = File.read("inputs/1.txt")
    processed = process(input)

    # Part 1
    processed
    |> Enum.count(fn {a, _} -> a == 0 end)
    |> IO.puts()

    # Part 2
    processed
    |> Enum.map(fn {_, b} -> b end)
    |> Enum.sum()
    |> IO.puts()
  end
end

Day1.run()
