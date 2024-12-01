require 'set'

lines = File.readlines("./inputs/day3.txt")

def priority(char) = char.ord - (char >= 'A' && char <= 'Z' ? 38 : 96)

def line_to_priority(line)
  p1, p2 = line.strip.chars.each_slice(line.length / 2).map(&:to_set)
  priority((p1 & p2).to_a.first)
end

def group_to_priority(group)
  p1, p2, p3 = group.map { |line| line.chars.to_set }
  priority((p1 & p2 & p3).to_a.first)
end

puts lines.map(&method(:line_to_priority)).sum
puts lines.each_slice(3).map(&method(:group_to_priority)).sum
