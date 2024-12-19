def neighbors(grid, v)
  x, y = v
  result = []
  if y > 0 && grid[y - 1][x] == "."
    result << [x, y - 1]
  end
  if y < grid.length - 1 && grid[y + 1][x] == "."
    result << [x, y + 1]
  end
  if x > 0 && grid[y][x - 1] == "."
    result << [x - 1, y]
  end
  if x < grid[0].length - 1 && grid[y][x + 1] == "."
    result << [x + 1, y]
  end
  result
end

def bfs(grid)
  start = [0, 0]
  ending = [grid[0].length - 1, grid.length - 1]
  q = [start]
  explored = Set.new
  explored << start
  parents = Hash.new
  until q.empty? do
    v = q.shift
    if v == ending
      break
    end
    for w in neighbors(grid, v) do
      if !explored.include?(w)
        explored << w
        q << w
        parents[w] = v
      end
    end
  end

  l = 0
  t = []
  p = ending
  while p do
    if p == start
      return [l, t, true]
    end
    # puts p.inspect
    t << p
    p = parents[p]
    l += 1
  end
  [l, t, false]
end

size = 70
points = STDIN.readlines.map { |l| l.split(',').map(&:to_i) }.take(3037)
grid = []
for y in 0..size
  grid << ['.'] * (size + 1)
end
for p in points
  grid[p[1]][p[0]] = '#'
end

l, t, f = bfs(grid)
for p in t
  grid[p[1]][p[0]] = 'O'
end
puts grid.map(&:join)
puts l
puts f
puts points.last.inspect
