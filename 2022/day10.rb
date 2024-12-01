lines = File.readlines './inputs/day10.txt'

DISPLAY_WIDTH = 40
DISPLAY_HEIGHT = 6

$registers = { 'x' => 1 }
$pixels = Array.new(DISPLAY_WIDTH * DISPLAY_HEIGHT, '.')
$position = 0

def draw_pixel
  if ($registers['x'] - $position % DISPLAY_WIDTH).abs <= 1
    $pixels[$position] = '#'
  end
  $position += 1
end

def process_instruction(instruction)
  parts = instruction.split ' '
  cycles = if parts.first == 'noop' then 1 else 2 end
  cycles.times do
    draw_pixel
  end
  if parts.first == 'addx'
    $registers['x'] += parts.last.to_i
  end
  cycles
end

counter = 0
strength_cycles = [20, 60, 100, 140, 180, 220]
strengths = lines.map(&:chomp).filter_map do |instruction|
  prev_value = $registers['x']
  counter += process_instruction instruction
  if !strength_cycles.empty? && counter >= strength_cycles.first
    val = prev_value * strength_cycles.first
    strength_cycles.shift
    val
  end
end

puts strengths.sum
puts $pixels.each_slice(DISPLAY_WIDTH).map(&:join).join "\n"
