lines = File.readlines('./inputs/day4.txt')

def part1(arr)
  a1, b1, a2, b2 = arr
  (a1 <= a2 && b2 <= b1) || (a2 <= a1 && b1 <= b2)
end

def part2(arr)
  a1, b1, a2, b2 = arr
  (b1 >= a2 && b1 <= b2) || (b2 >= a1 && b2 <= b1)
end

ranges = lines.map do |line|
  line.split(',').map { |aisles| aisles.split('-') }.flatten.map(&:to_i)
end

puts ranges.filter(&method(:part1)).count
puts ranges.filter(&method(:part2)).count
