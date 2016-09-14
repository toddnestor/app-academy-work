class HumanPlayer
  def initialize

  end

  def get_board(board)
  end

  def prompt
    puts "Make a guess (ex. 1,2)"
    guess = gets.chomp
    guess = guess.split(',').map { |val| val.to_i - 1 }

    guess
  end

  def prompt_enter
    puts "Press enter to continue"
    gets
  end

  def receive_board(board)
    board.render
  end

  def got_a_match(*args)
    puts "You got a match!"
  end
end
