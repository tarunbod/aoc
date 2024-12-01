require 'set'
require 'matrix'

lines = ARGF.read.split("\n").map(&:strip)
grid = lines.map { |line| line.split("") }
start_pos = nil
for y in 0...grid.length
  for x in 0...grid[y].length
    if grid[y][x] == "S"
      start_pos = [x, y]
      break
    end
  end
  break unless start_pos.nil?
end

def at(grid, pos)
  return nil if pos[0] < 0 || pos[0] >= grid[0].length || pos[1] < 0 || pos[1] >= grid.length
  grid[pos[1]][pos[0]]
end

def advance(grid, visited, ptr)
  nxt = nil
  case at(grid, ptr)
  when '-'
    nxt = [ptr[0] + 1, ptr[1]]
    nxt = [ptr[0] - 1, ptr[1]] if visited.include?(nxt)
  when '|'
    nxt = [ptr[0], ptr[1] + 1]
    nxt = [ptr[0], ptr[1] - 1] if visited.include?(nxt)
  when '7'
    nxt = [ptr[0] - 1, ptr[1]]
    nxt = [ptr[0], ptr[1] + 1] if visited.include?(nxt)
  when 'F'
    nxt = [ptr[0] + 1, ptr[1]]
    nxt = [ptr[0], ptr[1] + 1] if visited.include?(nxt)
  when 'L'
    nxt = [ptr[0] + 1, ptr[1]]
    nxt = [ptr[0], ptr[1] - 1] if visited.include?(nxt)
  when 'J'
    nxt = [ptr[0] - 1, ptr[1]]
    nxt = [ptr[0], ptr[1] - 1] if visited.include?(nxt)
  else
    raise "Unknown character at #{ptr.inspect}: #{at(grid, ptr)}"
  end
  nxt
end

def part1(grid, start_pos)
  ptrs = []
  first_step_chars = []
  if '-7J'.include?(at(grid, [start_pos[0] + 1, start_pos[1]]) || '!')
    ptrs << [start_pos[0] + 1, start_pos[1]]
    first_step_chars << at(grid, [start_pos[0] + 1, start_pos[1]])
  end
  if '-FL'.include?(at(grid, [start_pos[0] - 1, start_pos[1]]) || '!')
    ptrs << [start_pos[0] - 1, start_pos[1]]
    first_step_chars << at(grid, [start_pos[0] - 1, start_pos[1]])
  end
  if '|LJ'.include?(at(grid, [start_pos[0], start_pos[1] + 1]) || '!')
    ptrs << [start_pos[0], start_pos[1] + 1]
    first_step_chars << at(grid, [start_pos[0], start_pos[1] + 1])
  end
  if '|7F'.include?(at(grid, [start_pos[0], start_pos[1] - 1]) || '!')
    ptrs << [start_pos[0], start_pos[1] - 1]
    first_step_chars << at(grid, [start_pos[0], start_pos[1] - 1])
  end
  ptr_1 = ptrs[0]
  ptr_2 = ptrs[1]

  visited = Set.new([start_pos, ptr_1, ptr_2])
  path = [start_pos]
  steps = 1
  while ptr_1 != ptr_2
    steps += 1
    ptr_1 = advance(grid, visited, ptr_1)
    ptr_2 = advance(grid, visited, ptr_2)
    visited << ptr_1
    visited << ptr_2
    path << ptr_1
    if ptr_1 == ptr_2
      break
    end
    path.unshift(ptr_2)
  end
  puts "Part 1: #{steps}"
  path
end

def part2(grid, start_pos)
  the_loop = part1(grid, start_pos)
  total = 0
  for i in 0...grid.length
    inside = false
    for j in 0...grid[i].length
      if the_loop.include?([j, i])
        inside = !inside
        next
      end
      if inside
        puts [grid[i][j], [j, i], inside].inspect
        total += 1
      end
    end
    #puts
  end
  puts "Part 2: #{total}"
end

part2(grid, start_pos)
