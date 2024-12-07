def update(dir, l3c, l3d, y, x)
  dir = if dir == "^"
    ">"
  elsif dir == ">"
    "v"
  elsif dir == "v"
    "<"
  elsif dir == "<"
    "^"
  end

  l3d << dir
  if l3d.size > 3
    l3d.shift
  end

  l3c << [y, x]
  if l3c.size > 3
    l3c.shift
  end

  [dir, l3c, l3d]
end

def empty_vline(x, ystart, yend, grid)
  ymin = [ystart, yend].min
  ymax = [ystart, yend].max
  result = grid[ymin..ymax].map { |l| l[x] }.none? { |c| c == "#" }
  # puts "vline(x=#{x}, ystart=#{ystart}, yend=#{yend}) = #{result}"
  result
end

def empty_hline(y, xstart, xend, grid)
  xmin = [xstart, xend].min
  xmax = [xstart, xend].max
  result = grid[y][xmin..xmax].none? { |c| c == "#" }
  # puts "hline(y=#{y}, xstart=#{xstart}, xend=#{xend}) = #{result}"
  result
end

def print_with_obstacle(y, x, grid)
  newgrid = grid.map(&:clone).clone
  newgrid[y][x] = "O"
  puts newgrid.map(&:join)
end

lines = File.readlines("inputs/day6.sample.txt").map(&:strip)

y = lines.index { |l| l.index("^") != nil }
x = lines[y].index("^")

grid = lines.map(&:chars)
visited = Set[[y, x]]
l3d = []
l3c = []
dir = "^"
count = 0

while true
  if y == 0 || y == grid.length - 1 || x == 0 || x == grid[0].length - 1
    break
  end
  dir_change = false

  if dir == "^"
    if y > 0 && grid[y-1][x] == "#"
      dir, l3c, l3d = update(dir, l3c, l3d, y, x)
      dir_change = true
    else
      y = y - 1
    end
  elsif dir == ">"
    if x < grid[0].length - 1 && grid[y][x+1] == "#"
      dir, l3c, l3d = update(dir, l3c, l3d, y, x)
      dir_change = true
    else
      x = x + 1
    end
  elsif dir == "v"
    if y < grid.length - 1 && grid[y+1][x] == "#"
      dir, l3c, l3d = update(dir, l3c, l3d, y, x)
      dir_change = true
    else
      y = y + 1
    end
  elsif dir == "<"
    if x > 0 && grid[y][x-1] == "#"
      dir, l3c, l3d = update(dir, l3c, l3d, y, x)
      dir_change = true
    else
      x = x - 1
    end
  end
  visited << [y, x]

  if dir_change
    # puts l3c.inspect
    obstacle = case l3d
    when ["^", ">", "v"]
      # [l3c[0][0] + 1, l3c[2][1]] if empty_vline(l3c[2][1], l3c[0][0] + 1, l3c[1][0], grid)
      [l3c[0][0] + 1, l3c[2][1]] if empty_vline(l3c[2][1], l3c[0][0] + 1, l3c[1][0], grid)
    when [">", "v", "<"]
      [l3c[2][0], l3c[0][1] - 1] if empty_hline(l3c[2][0], l3c[0][1] - 1, l3c[1][1], grid)
    when ["v", "<", "^"]
      [l3c[0][0] - 1, l3c[2][1]] if empty_vline(l3c[2][1], l3c[0][0] - 1, l3c[1][0], grid)
    when ["<", "^", ">"]
      [l3c[2][0], l3c[0][1] + 1] if empty_hline(l3c[2][0], l3c[0][1] + 1, l3c[1][1], grid)
    end
    if obstacle
      puts "obstacle pos: #{obstacle.inspect}"
      # print_with_obstacle(obstacle[0], obstacle[1], grid)
      # puts "==================="
      count += 1
    end
  end
end

puts visited.size
puts count
