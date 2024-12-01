class Pos
  attr_accessor :x, :y, :parent

  def initialize(x, y)
    @x = x
    @y = y
  end

  def neighbors
    [Pos.new(@x, @y + 1), Pos.new(@x, @y - 1), Pos.new(@x - 1, @y), Pos.new(@x + 1, @y)]
  end

  def hash
    [@x, @y].hash
  end

  def eql?(other)
    self.class == other.class && @x == other.x && @y == other.y
  end
  #alias_method :eql?, :==

  def to_s
    "(#{x}, #{y})"
  end
end
