schematics = STDIN.readlines.map(&:strip).reject(&:empty?).map(&:chars).each_slice(7)
locks, keys = schematics.partition { |s| s[0].all? { |c| c == '#' } }
locks = locks.map { |l| l.transpose.map { |r| r.count('#') - 1 } }
keys = keys.map { |k| k.transpose.map { |r| r.count('#') - 1 } }

puts locks.product(keys).count { |l, k| l.zip(k).map(&:sum).all? { |v| v < 6 } }
