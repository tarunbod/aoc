def count_xmas(line)
  line.scan(/XMAS/).size + line.scan(/SAMX/).size
end

file = "inputs/day4.txt"

part1 = 0
substr = "XMAS"

horizontal_lines = File.readlines(file).map(&:strip)
maxl = horizontal_lines.size
part1 += horizontal_lines.map(&(method :count_xmas)).sum

vertical_lines = horizontal_lines.map(&:chars).transpose.map(&:join)
part1 += vertical_lines.map(&(method :count_xmas)).sum

reversed_lines = horizontal_lines.map(&:reverse)
vertical_reversed_lines = reversed_lines.map(&:chars).transpose.map(&:join)

diagonal_lines = []
(0...maxl).each do |i|
  a = (0...maxl).filter_map { |j| horizontal_lines[j][j+i] }.join
  b = (0...maxl).filter_map { |j| vertical_lines[j][j+i] }.join
  diagonal_lines << a
  diagonal_lines << b if i != 0

  c = (0...maxl).filter_map { |j| reversed_lines[j][j+i] }.join
  d = (0...maxl).filter_map { |j| vertical_reversed_lines[j][j+i] }.join
  diagonal_lines << c
  diagonal_lines << d if i != 0
end

part1 += diagonal_lines.map(&(method :count_xmas)).sum

puts part1
