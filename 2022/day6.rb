input = File.read('./inputs/day6.txt').chomp

# This is O(input * count), it can be faster but i don't care
def uniq_idx(input, count)
  input.chars.each_cons(count).each_with_index do |chars, i|
    break i + count if count == chars.uniq.count
  end
end

puts uniq_idx(input, 4)
puts uniq_idx(input, 14)
