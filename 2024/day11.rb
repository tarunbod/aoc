def blink(n)
  if n == "0"
    ["1"]
  elsif n.length % 2 == 0
    [n[0...n.length/2].to_i.to_s, n[n.length/2..].to_i.to_s]
  else
    [(n.to_i * 2024).to_s]
  end
end

def doit(nums, n)
  record = nums.tally
  n.times do |i|
    next_record = Hash.new(0)
    record.each do |num, count|
      blink(num).each do |b|
        next_record[b] += count
      end
    end
    record = next_record
  end
  record.values.sum
end

nums = STDIN.readline.split
puts doit(nums, 25)
puts doit(nums, 75)
