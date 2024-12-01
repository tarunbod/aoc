Monkey = Struct.new(:items, :op, :div, :pass, :failure, :inspected)

def parse_monkeys(lines)
  monkeys = Hash.new
  monkey_reps = lines.chunk { |line| !line.strip.empty? }.filter(&:first).map(&:last)
  monkey_reps.each do |name, start_items, operation, test, if_pass, if_fail|
    id = name.split(' ').last.to_i
    items = start_items.split(': ').last.split(', ').map(&:to_i)
    operator, var = operation.split('old ').last.split(' ')
    div = test.split('by ').last.to_i
    op = ->(x) {
      operand = var == 'old' ? x : var.to_i
      if operator == '*'
        x * operand
      else
        x + operand
      end
    }
    pass = if_pass.split('monkey ').last.to_i
    failure = if_fail.split('monkey ').last.to_i
    monkeys[id] = Monkey.new(items, op, div, pass, failure, 0)
  end
  monkeys
end

def turn(monkeys, id, mod, factor)
  monkey = monkeys[id]
  return if monkey.items.empty?

  monkey.items.each do |item|
    item = (monkey.op.call(item) % mod) / factor
    next_monkey = item % monkey.div == 0 ? monkey.pass : monkey.failure
    monkeys[next_monkey].items << item
    monkey.inspected += 1
  end
  monkey.items.clear
end

def run(monkeys, count, factor=1)
  mod = monkeys.values.map(&:div).reduce(&:*)
  count.times do |t|
    monkeys.count.times do |id|
      turn(monkeys, id, mod, factor)
    end
  end
  monkeys.values.map(&:inspected).max(2).reduce(:*)
end

def part1(lines)
  monkeys = parse_monkeys lines
  run(monkeys, 20, 3)
end

def part2(lines)
  monkeys = parse_monkeys lines
  run(monkeys, 10_000, 1)
end

lines = File.readlines './inputs/day11.txt'

puts part1(lines)
puts part2(lines)
