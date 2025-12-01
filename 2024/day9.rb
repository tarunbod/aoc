input = STDIN.readline.strip
disk = input.chars.each_slice(2).each_with_index.map do |layout, idx|
  a, b = layout
  result = ("#{idx}" * Integer(a))
  result += "." * Integer(b) if b
  result
end.join("").chars

# puts disk.join("")

left = disk.index "."
right = disk.length - 1
loop do
  tmp = disk[left]
  disk[left] = disk[right]
  disk[right] = tmp

  while left < disk.length && disk[left] != '.' do
    left += 1
  end
  while right >= 0 && disk[right] == '.' do
    right -= 1
  end
  break if left >= right
  # puts "#{right - left}"
end

# puts disk.join("")

puts disk.each_with_index.filter_map { |c, i| Integer(c) * i if c != '.' }.sum
