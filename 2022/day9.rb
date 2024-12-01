require 'set'

lines = [
  "R 5\n",
  "U 8\n",
  "L 8\n",
  "D 3\n",
  "R 17\n",
  "D 10\n",
  "L 25\n",
  "U 20\n",
]
lines = File.readlines './inputs/day9.txt'

def make_move(knots, visited, direction)
  head_delta = if direction == 'R' || direction == 'U' then 1 else -1 end
  vert = direction == 'U' || direction == 'D'
  if vert
    knots.first[1] += head_delta
  else
    knots.first[0] += head_delta
  end

  (knots.count - 1).times do |idx|
    dx = knots[idx][0] - knots[idx + 1][0]
    dy = knots[idx][1] - knots[idx + 1][1]
    if dx.abs > 1
      delta = if knots[idx][0] > knots[idx + 1][0] then 1 else -1 end
      knots[idx + 1][0] += delta
      if knots[idx][1] > knots[idx + 1][1]
        knots[idx + 1][1] += 1
      elsif knots[idx][1] < knots[idx + 1][1]
        knots[idx + 1][1] -= 1
      end
    elsif dy.abs > 1
      delta = if knots[idx][1] > knots[idx + 1][1] then 1 else -1 end
      knots[idx + 1][1] += delta
      if knots[idx][0] > knots[idx + 1][0]
        knots[idx + 1][0] += 1
      elsif knots[idx][0] < knots[idx + 1][0]
        knots[idx + 1][0] -= 1
      end
    end
  end

  pos = "#{knots.last[0]},#{knots.last[1]}"
  visited.add(pos)
end

part1_knots = Array.new(2) { [0, 0] }
part1_visited = Set.new
part2_knots = Array.new(10) { [0, 0] }
part2_visited = Set.new
lines.map(&:chomp).each do |move|
  direction, amount = move.split ' '
  amount.to_i.times do
    make_move(part1_knots, part1_visited, direction)
    make_move(part2_knots, part2_visited, direction)
  end
end

puts part1_visited.count
puts part2_visited.count
