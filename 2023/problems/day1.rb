# frozen_string_literal: true

LINES = ARGF.read.split("\n").map(&:strip)
WORDS_TO_DIGITS = {
  'one' => 1,
  'two' => 2,
  'three' => 3,
  'four' => 4,
  'five' => 5,
  'six' => 6,
  'seven' => 7,
  'eight' => 8,
  'nine' => 9
}.freeze
WORDS = WORDS_TO_DIGITS.keys.freeze

class String
  def is_digit? = ord >= 49 && ord <= 57
end

def part1
  ans = LINES.filter_map do |l|
    digits = l.chars.filter_map { |c| c.to_i if c.is_digit? }
    digits.first * 10 + digits.last unless digits.empty?
  end.sum
  puts ans
end

def part2
  ans = LINES.map do |l|
    word_first = WORDS.filter_map { |w| [WORDS_TO_DIGITS[w], l.index(w)] if l.index(w) }.min_by(&:last)
    word_last = WORDS.filter_map { |w| [WORDS_TO_DIGITS[w], l.rindex(w)] if l.rindex(w) }.max_by(&:last)
    digits = l.chars.filter_map.with_index do |c, i|
      next word_first[0] if word_first && i == word_first[1]
      next word_last[0] if word_last && i == word_last[1]
      c.to_i if c.is_digit?
    end
    digits.first * 10 + digits.last
  end.sum
  puts ans
end

part1
part2
