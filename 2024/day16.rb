def neighbors(grid, prev, u, q)
  y, x = u
  py, px = prev || [nil, nil]
  n = []
  if y > 0 && q.include?([y-1, x]) && grid[y-1][x] != "#"
    w = x == px ? 1 : 1001
    n << [[y-1, x], w]
  end
  if y < grid.length - 1 && q.include?([y+1, x]) && grid[y+1][x] != "#"
    w = x == px ? 1 : 1001
    n << [[y+1, x], w]
  end
  if x > 0 && q.include?([y, x-1]) && grid[y][x-1] != "#"
    w = y == py ? 1 : 1001
    n << [[y, x-1], w]
  end
  if x < grid[y].length - 1 && q.include?([y, x+1]) && grid[y][x+1] != "#"
    w = y == py ? 1 : 1001
    n << [[y, x+1], w]
  end
  n
end

def dijk(grid, start)
  dist = Hash.new(2 ** 64 - 1)
  dist[start] = 0
  prev = {}
  prev[start] = [start[0], start[1] - 1]
  q = Set.new
  for i in 0...grid.length
    for j in 0...grid[i].length
      q << [i, j] if grid[i][j] != "#"
    end
  end
  # puts "Start: #{start.inspect}"
  # puts "Dist: #{dist.inspect}"

  while !q.empty?
    u = q.min_by { |v| dist[v] }
    p = prev[u]
    q.delete(u)
    for v, w in neighbors(grid, p, u, q)
      alt = dist[u] + w
      puts "p: #{p}, u: #{u.inspect}, v: #{v.inspect}, w: #{w}, alt: #{alt}"
      if alt < dist[v]
        dist[v] = alt
        prev[v] = u
      end
      # puts "dist: #{dist.inspect}, prev: #{prev.inspect}"
    end
  end
  return dist, prev
end

grid = STDIN.readlines.map(&:chomp).map(&:chars)
start = nil
endc = nil
for i in 0...grid.length
  for j in 0...grid[i].length
    if grid[i][j] == "S"
      start = [i, j]
    end
    if grid[i][j] == "E"
      endc = [i, j]
    end
    break if start && endc
  end
  break if start && endc
end
dist, prev = dijk(grid, start)
puts dist[endc]

path = []
u = endc
while u != start
  path << u
  u = prev[u]
  break if u == start
end
for p in path.drop(1)
  y, x = p
  grid[y][x] = "O"
end

puts grid.map(&:join)
