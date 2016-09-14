require 'set'
require_relative 'player'

class Game
  attr_accessor :fragment, :dictionary, :players, :losses

  def initialize(players)
    @players = players
    @fragment = ""
    @current_index = 0
    @losses = {}
    populate_losses
    populate_dictionary
  end

  def current_player
    @players[@current_index]
  end

  def previous_player
    return @players.last if @current_index == 0
    @players[ @current_index - 1]
  end

  def next_player!
    @current_index += 1
    @current_index = @current_index % (@players.length)
  end

  def take_turn(player)
    letter = player.guess

    unless valid_play?(letter)
      until valid_play?(letter)
        puts "Guess was invalid, please try again."
        letter = player.guess
      end
    end

    @fragment << letter
  end

  def run
    until players.length == 1
      display_players
      until player_lost?
        play_round
        display_record
        @fragment = ""
      end

      @players.delete(loser)
      puts "Game over, #{@players[0].name} won!"
    end
  end

  def play_round
    until round_over?
      puts "Current fragment is #{@fragment}" if @fragment.length > 0

      take_turn(current_player)
      next_player!
    end

    puts "Round over, #{previous_player.name} lost."
    @losses[previous_player] += 1
  end

  def valid_play?(string)
    return false if string.nil?
    string.match(/^[a-z]{1,1}$/) && word_starts_with?(@fragment + string)
  end

  def round_over?
    @dictionary.include?(@fragment)
  end

  private
  def populate_dictionary
    File.open('dictionary.txt') do |f|
      @dictionary = f.readlines
    end
    @dictionary.map! {|word| word.chomp}

    @dictionary = Set.new @dictionary
  end

  def display_record
    @losses.each do |player, count|
      puts "#{player.name} has: #{ghostify(count)}" if @players.include?(player)
    end
  end

  def loser
    @losses.each do |player, count|
      return player if count == 5 && @players.include?(player)
    end
  end

  def ghostify(num)
    final_index = num - 1
    return "GHOST"[0..final_index] if final_index >= 0
    ""
  end

  def player_lost?
    @losses.any? do |player, count|
      count == 5 && @players.include?(player)
    end
  end

  def populate_losses
    @players.each {|player| @losses[player] = 0}
  end

  def display_players
    names = []
    @players.each {|player| names << player.name}
    puts "The current players are #{names.join(", ")}"
  end

  def word_starts_with?(string)
    @dictionary.each do |word|
      return true if word[0...string.length] == string
    end

    false
  end
end

players = [
  Player.new("John"),
  Player.new("Bill"),
  Player.new("Alfred")
]
game = Game.new(players)

game.run
