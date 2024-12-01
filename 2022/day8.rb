lines = File.readlines('./inputs/day8.txt')

grid = lines.map { |line| line.chomp.chars.map(&:to_i) }

def part1(grid)
  transpose = grid.transpose
  num_visible_by_row = grid.map.with_index do |row, y|
    visible = row.filter_map.with_index do |tree, x|
      top    = transpose[x][0...y].all? { |h| h < tree }
      left   = grid[y][0...x].all? { |h| h < tree }
      right  = grid[y][(x+1)..].all? { |h| h < tree }
      bottom = transpose[x][(y+1)..].all? { |h| h < tree }
      top || left || right || bottom
    end
    visible.count
  end
  num_visible_by_row.sum
end

def scenic_score(trees, height)
  idx = trees.index { |h| h >= height }
  if idx.nil?
    trees.count
  else
    idx + 1
  end
end

def part2(grid)
  transpose = grid.transpose
  scenic_scores = grid.map.with_index do |row, y|
    row.map.with_index do |tree, x|
      top    = scenic_score(transpose[x][0...y].reverse, tree)
      right  = scenic_score(grid[y][(x+1)..], tree)
      bottom = scenic_score(transpose[x][(y+1)..], tree)
      left   = scenic_score(grid[y][0...x].reverse, tree)
      top * right * bottom * left 
    end
  end
  scenic_scores.flatten.max
end

puts part1(grid)
puts part2(grid)
