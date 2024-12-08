grid = STDIN.read.split("\n").map(&:chars)
size = grid.size
freqs = Hash.new { |h, k| h[k] = [] }
grid.each_with_index do |row, y|
  row.each_with_index do |c, x|
    if c != '.'
      freqs[c] << [y, x]
    end
  end
end

def in_bounds(n1, size)
  n1[0] >= 0 && n1[0] < size && n1[1] >= 0 && n1[1] < size
end

def count_antinodes(freqs, size, part2)
  count = 0
  antinodes = Set.new
  freqs.each do |f, antenna|
    antenna.combination(2).each do |a1, a2|
      if part2
        antinodes << a1
        antinodes << a2
      end

      n = 0
      while true do
        n += 1
        n1 = [a1[0] + n * (a1[0] - a2[0]), a1[1] + n * (a1[1] - a2[1])]
        if !in_bounds(n1, size)
          break
        end
        antinodes << n1
        if !part2
          break
        end
      end

      n = 0
      while true do
        n += 1
        n2 = [a2[0] + n * (a2[0] - a1[0]), a2[1] + n * (a2[1] - a1[1])]
        if !in_bounds(n2, size)
          break
        end
        antinodes << n2
        if !part2
          break
        end
      end
    end
  end

  puts antinodes.size + count
end

count_antinodes(freqs, size, false)
count_antinodes(freqs, size, true)
