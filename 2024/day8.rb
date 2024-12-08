def get_antinode_pos(a1, a2, n)
  [a1[0] + n * (a1[0] - a2[0]), a1[1] + n * (a1[1] - a2[1])]
end

def in_bounds(pos, size)
  pos[0] >= 0 && pos[0] < size && pos[1] >= 0 && pos[1] < size
end

def get_antinodes_in_bounds(a1, a2, size, maxn)
  n = 1
  antinodes = Set.new
  while n <= maxn do
    antinode = get_antinode_pos(a1, a2, n)
    break unless in_bounds(antinode, size)
    antinodes << antinode
    n += 1
  end
  antinodes
end

def count_antinodes(grid, part2)
  size = grid.size
  freqs = Hash.new { |h, k| h[k] = [] }
  grid.each_with_index do |row, y|
    row.each_with_index do |c, x|
      freqs[c] << [y, x] if c != '.'
    end
  end

  antinodes = Set.new
  freqs.each do |f, antenna|
    antenna.combination(2).each do |a1, a2|
      maxn = part2 ? 1000 : 1
      antinodes += [a1, a2] if part2
      antinodes += get_antinodes_in_bounds(a1, a2, size, maxn)
      antinodes += get_antinodes_in_bounds(a2, a1, size, maxn)
    end
  end

  antinodes.size
end

grid = STDIN.read.split("\n").map(&:chars)
puts count_antinodes(grid, false)
puts count_antinodes(grid, true)
