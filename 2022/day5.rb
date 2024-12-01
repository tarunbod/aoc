# lines = [
#   "    [D]    \n",
#   "[N] [C]    \n",
#   "[Z] [M] [P]\n",
#   " 1   2   3 \n",
#   "\n",
#   "move 1 from 2 to 1\n",
#   "move 3 from 1 to 3\n",
#   "move 2 from 2 to 1\n",
#   "move 1 from 1 to 2\n"
# ]
lines = File.readlines("./inputs/day5.txt")

def row_to_items(line)
  line.chars.each_slice(4).map { |col| col[1] }
end

moves, stacks = lines.map(&:chomp).partition { |line| line.start_with?('move') }
moves.map! { |line| line.match(/move (\d+) from (\d+) to (\d+)/).captures.map(&:to_i) }
stacks.pop(2)
stacks = stacks.map(&method(:row_to_items)).transpose.map { |stack| stack.reject { |item| item.strip.empty? } }

def part1(moves, stacks)
  stacks = stacks.map(&:dup)
  moves.each do |count, col1, col2|
    stacks[col2 - 1].prepend(*stacks[col1 - 1].shift(count).reverse)
  end
  stacks.map(&:first).join 
end

def part2(moves, stacks)
  stacks = stacks.map(&:dup)
  moves.each do |count, col1, col2|
    stacks[col2 - 1].prepend(*stacks[col1 - 1].shift(count))
  end
  stacks.map(&:first).join 
end

puts part1(moves, stacks)
puts part2(moves, stacks)
