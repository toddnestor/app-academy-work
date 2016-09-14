require_relative 'board'
require_relative 'human-player'
require_relative 'computer-player'

class Game
  attr_accessor :previous_guess, :current_guess, :player

  def initialize(player)
    @board = get_board
    @player = player
    @player.get_board(@board)
    @turns = 0
  end

  def play
    @board.render_bombs

    until over?
      system("clear")
      take_turn
    end

    render
    conclude
  end

  def get_board
    puts "Hey, how difficult do you want this to be?\n Huh, are you chicken?\n Enter a number"
    size = gets.chomp.to_i
    Board.new(size)
  end

  def take_turn
    render
    make_guess(@player.prompt)
    render
    make_guess(@player.prompt)
    render
    @player.prompt_enter
    check_guess
    @turns += 1
  end

  def over?
    @board.won? || @turns == @board.turns_limit
  end

  def render
    @player.receive_board(@board)
  end

  def make_guess(pos)
    @board.reveal(*pos)
    @previous_guess = @current_guess
    @current_guess = pos
  end

  def check_guess
    if cards_match?
      @player.got_a_match(@current_guess, @previous_guess)
    else
      current_card.hide
      previous_card.hide
    end
  end

  def cards_match?
    current_card == previous_card && @current_guess != @previous_guess
  end

  def current_card
    @board[*@current_guess]
  end

  def previous_card
    @board[*@previous_guess]
  end

  def conclude
    if @board.won?
      puts "You won!\n"
    else
      puts "You lost, looser\n"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  player = HumanPlayer.new
  player = ComputerPlayer.new
  Game.new(player).play
end
