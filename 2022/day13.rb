def right_order?(left, right)
  Array.new([left.count, right.count].max).zip(left, right) do |_, l, r|
    return false if r.nil?
    return true if l.nil?

    if l.kind_of?(Integer) && r.kind_of?(Integer)
      next if r == l
      return l < r
    else
      r = [r] if r.kind_of?(Integer)
      l = [l] if l.kind_of?(Integer)

      sub_list = right_order?(l, r)
      return sub_list if !sub_list.nil?
    end
  end
  nil
end

def part1(lines)
  success_indices = lines.each_slice(3).filter_map.with_index do |pair, idx|
    # cheating by using eval because ain't no way i'm parsing recursive lists
    left = eval pair[0]
    right = eval pair[1]
    idx + 1 if right_order?(left, right)
  end
  success_indices.sum
end

def part2(lines)
  sorted_lists = lines.reject { |line| line.strip.empty? }.map { |line| eval line }.chain([[[2]], [[6]]]).sort do |a, b|
    right_order?(a, b) ? -1 : 1
  end
  idx1 = sorted_lists.find_index([[2]])
  idx2 = sorted_lists.find_index([[6]])
  (idx1 + 1) * (idx2 + 1)
end

lines = File.readlines './inputs/day13.txt'
puts part1(lines)
puts part2(lines)
