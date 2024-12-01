require 'set'
require './lib/pos'

def path(last_node, grid)
  count = 0
  while last_node.parent != nil
    count += 1
    last_node = last_node.parent
  end
  count
end

def hill_climb_bfs(start_pos, end_pos, grid)
  q = [start_pos]
  explored = [start_pos].to_set
  while !q.empty?
    next_pos = q.shift
    if next_pos == end_pos
      return path(next_pos, grid)
    end

    neighbors = next_pos.neighbors.select do |n|
      next unless n.x >= 0 && n.x < grid.first.count && n.y >= 0 && n.y < grid.count
      cur = grid[next_pos.y][next_pos.x]
      nxt = grid[n.y][n.x]
      cur = 'a' if cur == 'S'
      nxt = 'a' if nxt == 'S'
      nxt = 'z' if nxt == 'E'
      nxt.ord <= cur.ord + 1
    end
    neighbors.each do |n|
      if !explored.include? n
        explored.add n
        n.parent = next_pos
        q << n
      end
    end
  end
end

grid = File.readlines('./inputs/day12.txt').map(&:chars)

def part1(grid)
  flat = grid.flatten
  start_idx = flat.find_index 'S'
  start_pos = Pos.new(start_idx % grid.first.count, start_idx / grid.first.count) 
  end_idx = flat.find_index 'E'
  end_pos = Pos.new(end_idx % grid.first.count, end_idx / grid.first.count)
  hill_climb_bfs(start_pos, end_pos, grid)
end

def part2(grid)
  flat = grid.flatten
  end_idx = flat.find_index 'E'
  end_pos = Pos.new(end_idx % grid.first.count, end_idx / grid.first.count)
  results = flat.each_with_index.filter_map do |c, i|
    if c == 'a'
      start_pos = Pos.new(i % grid.first.count, i / grid.first.count)
      hill_climb_bfs(start_pos, end_pos, grid)
    end
  end
  results.min
end

puts part1(grid)
puts part2(grid)
