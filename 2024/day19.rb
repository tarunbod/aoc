def count_valid(patterns, design)
  def check_valid(patterns, design, memo)
    return memo[design] if memo.include?(design)
    if design == ""
      memo[design] = 1
    else
      potential_patterns = patterns.filter { |p| design.start_with?(p) }
      if potential_patterns.empty?
        memo[design] = 0
      else
        memo[design] = potential_patterns.map { |p| check_valid(patterns, design[p.length..], memo) }.sum
      end
    end
  end
  check_valid(patterns, design, {})
end

lines = STDIN.readlines.map(&:chomp)
patterns = lines[0].split(', ')
designs = lines.drop(2)

num_valid = designs.map { |d| count_valid(patterns, d) }
puts num_valid.count { |d| d != 0 }
puts num_valid.sum
