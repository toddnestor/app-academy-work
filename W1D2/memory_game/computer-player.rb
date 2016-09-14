class ComputerPlayer
  def initialize
    @known_positions = {}
    @guesses = []
  end

  def receive_board(board)
    board.render

    board.each_with_pos do |card, pos|
      if card.face_up && !@known_positions[pos]
        @known_positions[pos] = {value: card.value, cleared: false}
      end
    end
  end

  def got_a_match(*positions)
    positions.each { |pos| @known_positions[pos][:cleared] = true }
  end

  def prompt
    guess = nil

    unless first_guess?
      last_guess = @guesses.last
      guess = match(last_guess) if match(last_guess)
    end

    if guess.nil?
      guess = known_match ? known_match : random_guess
    end

    update_guesses(guess)
    p guess
    guess
  end

  def update_guesses(guess)
    @guesses << guess
    @unknown_positions.delete(guess)
  end

  def first_guess?
    @guesses.length == 0
  end

  def uncleared_positions
    @known_positions.select {|_, status| !status[:cleared]}
  end

  def known_match
    uncleared_positions.each do |pos, status|
      return match(pos) if match(pos)
    end
    false
  end

  def match(position)
    matches = @known_positions.each do |pos, status|
      if position != pos && status[:value] == @known_positions[position][:value] && !@guesses.include?(pos)
        return pos
      end
    end

    false
  end

  def random_guess
    @unknown_positions.sample
  end

  def prompt_enter
    sleep(1)
    @guesses = []
  end

  def get_board(board)
    @unknown_positions = []
    board.each_with_pos { |_, pos| @unknown_positions << pos }
  end
end
