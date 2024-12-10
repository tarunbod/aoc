def neighbors(grid, v)
  result = []
  if v[0] > 0
    p = [v[0] - 1, v[1]]
    result << p if grid[p[0]][p[1]] == grid[v[0]][v[1]] + 1
  end
  if v[0] < grid.length - 1
    p = [v[0] + 1, v[1]]
    result << p if grid[p[0]][p[1]] == grid[v[0]][v[1]] + 1
  end
  if v[1] > 0
    p = [v[0], v[1] - 1]
    result << p if grid[p[0]][p[1]] == grid[v[0]][v[1]] + 1
  end
  if v[1] < grid[0].length - 1
    p = [v[0], v[1] + 1]
    result << p if grid[p[0]][p[1]] == grid[v[0]][v[1]] + 1
  end
  result
end

def bfs(grid, start)
  q = []
  explored = Set.new
  explored << start
  q << start
  parents = Hash.new { |h, k| h[k] = [] }
  results = Set.new
  until q.empty? do
    v = q.shift
    if grid[v[0]][v[1]] == 9
      results << v
    end
    for w in neighbors(grid, v) do
      if !explored.include?(w)
        explored << w
        q << w
      end
      parents[w] << v
    end
  end
  [results, parents]
end

def part1(grid, starts)
  puts starts.map { |s| bfs(grid, s)[0].size }.sum
end

def part2(grid, starts)
  all = starts.map do |s|
    results, parents = bfs(grid, s)
    def count_paths_to_0(grid, parents, root)
      p = parents[root]
      if p.size == 1 && grid[p[0][0]][p[0][1]] == 0
        1
      else
        p.map { |root_parent| count_paths_to_0(grid, parents, root_parent) }.sum
      end
    end
    results.map { |r| count_paths_to_0(grid, parents, r) }.sum
  end
  puts all.sum
end

grid = STDIN.readlines.map(&:strip).map(&:chars).map { |l| l.map { |c| c == '.' ? -1 : c.to_i } }
starts = []
for y in 0...grid.length
  for x in 0...grid[0].length
    starts << [y,x] if grid[y][x] == 0
  end
end
part1(grid, starts)
part2(grid, starts)
