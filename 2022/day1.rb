lines = File.readlines('./inputs/day1.txt')

# Part 1
calories = lines.map(&:to_i).chunk_while { |a, b| b != 0 }.map(&:sum)
puts calories.max

# Part 2
puts calories.max(3).sum
