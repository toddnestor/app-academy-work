require 'rainbow'

class Tile
  include Comparable

  attr_reader :value, :given

  def initialize(value = nil, given = false)
    @value = value
    @given = given
  end

  def to_s
    value = @value.nil? ? '_' : @value.to_s

    return Rainbow(value).blue if @given
    value
  end

  def set_value(val)
    @value = val unless @given
  end

  def <=>(tile)
    puts "A tile follows"
    p tile
    puts
    @value <=> tile.value
  end
end
