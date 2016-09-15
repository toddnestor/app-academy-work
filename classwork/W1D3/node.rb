class Node
  attr_accessor :parent, :value

  def initialize(value, parent = nil)
    @value = value
    @parent = parent
  end
end
