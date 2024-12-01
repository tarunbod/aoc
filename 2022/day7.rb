lines = File.readlines('./inputs/day7.txt')

TOTAL_SPACE = 70_000_000
SPACE_NEEDED = 30_000_000

stack = []
dir_sizes = {}

lines.map(&:chomp).each do |line|
  parts = line.split(' ')
  if parts.first == '$'
    next if parts[1] == 'ls'

    dirname = parts.last
    if dirname == '..'
      name, size = stack.pop 
      dir_sizes[name] = size
      stack.last[-1] += size
    else
      new_child = stack.map(&:first).append(dirname).join('/')
      stack << [new_child, 0]
    end
  else
    next if parts.first == 'dir'
    stack.last[-1] += parts.first.to_i
  end
end

while stack.count > 0
  name, size = stack.pop
  dir_sizes[name] = size
  stack.last[-1] += size if stack.count > 0
end

free_space = TOTAL_SPACE - dir_sizes['/']
space_needed = SPACE_NEEDED - free_space
puts dir_sizes.select { |_, size| size <= 100000 }.values.sum
puts dir_sizes.select { |_, size| size >= space_needed }.values.min
