require_relative 'board'

class Game
  def initialize(board)
    @board = board
  end

  def play
    @board.render
    until @board.solved?
      get_guess
      system("clear")
      @board.render
    end

    puts "Hey, you won, congrats!"
  end

  def get_guess
    pos = get_pos
    value = get_val

    @board[*pos].set_value(value)
  end

  def get_pos
    pos = nil

    until valid_position?(pos)
      pos = prompt("Pick a position (i.e. 3,3)")
      pos = pos.split(',').map {|idx| idx.to_i - 1}
    end

    pos
  end

  def valid_position?(pos)
    return false if pos.nil?
    pos.length == 2 && pos.all?{|num| (1..9).cover?(num)}
  end

  def get_val
    value = nil

    until valid_value?(value)
      value = prompt("Enter a value (i.e. 1)").to_i
    end

    value
  end

  def valid_value?(value)
    return false if value.nil?
    (1..9).cover?(value)
  end

  def prompt(message)
    puts message
    gets.chomp
  end
end


if __FILE__ == $PROGRAM_NAME
  board = Board.from_file('puzzles/almost.txt')
  game = Game.new(board)
  game.play
end
