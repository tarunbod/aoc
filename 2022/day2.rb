lines = File.readlines('./inputs/day2.txt')

def part1(opponent, player)
  win = (player == 'Y' && opponent == 'A') ||
    (player == 'Z' && opponent == 'B') ||
    (player == 'X' && opponent == 'C')
  draw = (player == 'X' && opponent == 'A') ||
    (player == 'Y' && opponent == 'B') ||
    (player == 'Z' && opponent == 'C')
  shape = 1
  if player == 'Y'
    shape = 2
  end
  if player == 'Z'
    shape = 3
  end
  outcome = win ? 6 : (draw ? 3 : 0)
  return shape + outcome 
end

def part2(opponent, ends)
  outcome = ends == 'Z' ? 6 : (ends == 'Y' ? 3 : 0)
  if ends == 'X'
    shape = opponent == 'A' ? 3 : (opponent == 'B' ? 1 : 2)
  elsif ends == 'Y'
    shape = opponent == 'A' ? 1 : (opponent == 'B' ? 2 : 3)
  else
    shape = opponent == 'A' ? 2 : (opponent == 'B' ? 3 : 1)
  end
  return shape + outcome
end

puts lines.map { |line| part1(*line.split(' ')) }.sum
puts lines.map { |line| part2(*line.split(' ')) }.sum
