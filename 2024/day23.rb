def fully_connected(graph, vertices)
  vertices.combination(2).all? { |a, b| graph[a].include?(b) }
end

def part1(graph)
  groups = []
  graph.keys.combination(3) do |arr|
    groups << arr if fully_connected(graph, arr) && arr.any? { |v| v.start_with?("t") }
  end
  groups.length
end

def part2(graph)
  graph.keys.length.downto(3) do |i|
    graph.keys.combination(i) do |arr|
      return arr.sort.join(",") if fully_connected(graph, arr)
    end
  end
end

graph = Hash.new { |h, k| h[k] = Set.new }
STDIN.readlines.each do |s|
  k, v = s.chomp.split('-')
  graph[k] <<= v
  graph[v] <<= k
end

puts part1(graph)
#puts part2(graph)
