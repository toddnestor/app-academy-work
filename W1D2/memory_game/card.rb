class Card
  attr_accessor :value, :face_up

  def initialize(value)
    @value = value
    @face_up = false
  end

  def hide
    @face_up = false
  end

  def reveal
    @face_up = true
  end

  def to_s
    @face_up ? @value.to_s : "X"
  end

  def ==(card)
    @value == card.value
  end
end
