require 'tsort'

class Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end
end

def get_tsort(rules, nums)
  deps = Hash.new { |h, k| h[k] = [] }
  rules.filter { |a, b| nums.include?(a) && nums.include?(b) }.each { |a, b|
    deps[b] << a
    deps[a]
  }
  deps.tsort
end

file = 'inputs/day5.txt'
lines = File.readlines(file).map(&:strip)
split_idx = lines.index("")
rules, updates = lines[0...split_idx], lines[split_idx+1..]

rules.map! do |rule|
  rule.split("|").map { |s| Integer(s) }
end

updates.map! do |update|
  update.split(",").map { |s| Integer(s) }
end

puts updates.filter_map { |nums|
  sorted = get_tsort(rules, nums)
  nums[nums.size / 2] if nums == sorted
}.sum

puts updates.filter_map { |nums|
  sorted = get_tsort(rules, nums)
  sorted[sorted.size / 2] if nums != sorted
}.sum
