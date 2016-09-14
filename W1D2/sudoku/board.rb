require_relative 'tile'

class Board
  attr_reader :grid

  VALUES = (1..9).to_a

  def initialize(grid)
    @grid = grid
  end

  def render
    @grid.each do |row|
      puts row.map(&:to_s).join(' ')
    end
  end

  def solved?
    rows_solved? && cols_solved? && squares_solved?
  end

  def self.parse_line(line)
    line.chars.map do |num|
      num = num.to_i

      if num > 0
        Tile.new(num, true)
      else
        Tile.new
      end
    end
  end

  def self.from_file(path)
    grid = []

    File.readlines(path).each do |line|
      line = line.chomp
      grid << Board.parse_line(line)
    end

    Board.new(grid)
  end

  def [](row, col)
    @grid[row][col]
  end

  # private

  def rows
    @grid
  end

  def cols
    sections = []

    9.times do |col|
      section = []
      @grid.each { |row| section << row[col] }
      sections << section
    end

    sections
  end

  def squares
    sections = Array.new(9) { [] }

    @grid.each_with_index do |row, index1|
      square_row = index1 / 3
      row.each_with_index do |tile, index2|
        square_col = index2 / 3
        section_index = (square_row * 3) + square_col
        sections[section_index] << tile
      end
    end

    sections
  end

  def rows_solved?
    section_solved?(rows)
  end

  def section_solved?(sections)
    sections = sections.map do |section|
      section.map do |tile|
        tile.value
      end
    end

    return false if sections.flatten.any? { |value| value.nil? }

    sections.all? {|section| section.sort == VALUES}
  end

  def cols_solved?
    section_solved?(cols)
  end

  def squares_solved?
    section_solved?(squares)
  end
end

if __FILE__ == $PROGRAM_NAME
  board = Board.from_file('puzzles/incorrect.txt')
  board.render

  puts "Was it solved? #{board.solved? ? "YES" : "NO :("}"
end
