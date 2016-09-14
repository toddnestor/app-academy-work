class Player
  attr_accessor :name

  def initialize (name)
    @name = name
  end

  def guess
    puts "#{@name}, guess a letter:"
    gets.chomp
  end
end
