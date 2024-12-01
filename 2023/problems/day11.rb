lines = ARGF.read.split("\n").map(&:strip)
grid = lines.map(&:chars)

expanded_rows = grid.filter_map.with_index { |row, y| y if row.all? { |c| c == '.' } }
expanded_cols = grid.transpose
  .filter_map.with_index { |col, x| x if col.all? { |c| c == '.' } }

range = (0...lines.size).to_a
galaxy_poses = range.product(range).filter { |x, y| grid[y][x] == '#' }

def sum_of_expanded_distances(galaxy_poses, expanded_rows, expanded_cols, expansion)
  galaxy_poses.combination(2).map do |(x1, y1), (x2, y2)|
    minx, maxx = [x1, x2].minmax
    miny, maxy = [y1, y2].minmax
    expanded = (minx..maxx).count { |x| expanded_cols.include?(x) }
    expanded += (miny..maxy).count { |y| expanded_rows.include?(y) }
    (maxx - minx) + (maxy - miny) + expanded * (expansion - 1)
  end.sum
end

puts sum_of_expanded_distances(galaxy_poses, expanded_rows, expanded_cols, 2)
puts sum_of_expanded_distances(galaxy_poses, expanded_rows, expanded_cols, 1_000_000)
