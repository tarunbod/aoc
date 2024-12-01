require 'set'
require './lib/pos'

def range(a1, a2)
  if a2 < a1
    a2..a1
  else
    a1..a2
  end
end

blocked = Set.new
lines = File.readlines('./inputs/day14.txt')

lines.each do |line|
  points = line.chomp.split(' -> ').map { |point| point.split(',').map(&:to_i) }
  points.each_cons(2) do |p1, p2|
    x1, y1 = p1
    x2, y2 = p2
    walls = if x1 == x2
      range(y1, y2).map { |y| Pos.new(x1, y) }
    else
      range(x1, x2).map { |x| Pos.new(x, y1) }
    end
    walls.each do |pos|
      blocked.add pos
    end
  end
end

floor = blocked.map(&:y).max + 2
left = blocked.map(&:x).min - 2000
right = blocked.map(&:x).max + 2000
(left..right).each do |x|
  blocked.add Pos.new(x, floor)
end

fell_out = false
step = 0
while true
  rock = Pos.new(500, 0)
  while true
    if rock.y >= floor - 1 && !fell_out
      fell_out = true
      puts step
    end
    if !blocked.include?(Pos.new(rock.x, rock.y + 1))
      rock = Pos.new(rock.x, rock.y + 1)
    elsif !blocked.include?(Pos.new(rock.x - 1, rock.y + 1))
      rock = Pos.new(rock.x - 1, rock.y + 1)
    elsif !blocked.include?(Pos.new(rock.x + 1, rock.y + 1))
      rock = Pos.new(rock.x + 1, rock.y + 1)
    else
      break
    end
  end
  if rock.x == 500 && rock.y == 0
    puts step + 1
    break
  end
  blocked.add(rock)
  step += 1
end
