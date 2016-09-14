require_relative 'card'

class Board
  attr_accessor :grid

  def initialize(size)
    @size = size
    @grid = populate
  end

  def populate
    dummy_grid = grid_array
    values = get_values

    dummy_grid.each do |row|
      row.map! do |el|
        Card.new(values.pop)
      end
    end

    @grid = dummy_grid
  end

  def [](row,col)
    @grid[row][col]
  end

  def get_values
    value_count = @size * (column_count) / 2

    values = (1..value_count).to_a

    bombify(values)

    (values + values).shuffle
  end

  def bombify(values)
    bombs_count = values.length / 10 + 1
    bombs_count.times do
      values.pop
      values.unshift('B')
    end
  end

  def render_bombs
    toggle_bombs(face_up: true)
    render
    sleep(5)
    system("clear")
    toggle_bombs(face_up: false)
  end

  def toggle_bombs(options = {})
    default_options = {face_up: false}
    options = default_options.merge(options)

    each_with_pos do |card|
      if options[:face_up]
        card.reveal if card.value == 'B'
      else
        card.hide if card.value == 'B'
      end
    end
  end

  def turns_limit
    @size * @size + 3
  end

  def grid_array
    Array.new(@size) do
      Array.new(column_count)
    end
  end

  def render
    puts "  #{(1..column_count).to_a.join('  ')}"
    @grid.each_with_index do |row, idx|
      puts "#{idx + 1} #{row.map(&:to_s).join('  ')}"
    end
  end

  def won?
    @grid.flatten.all? { |card| card.face_up }
  end

  def reveal(row,col)
    @grid[row][col].reveal
  end

  def column_count
    @size.odd? ? @size + 1 : @size
  end

  def each_with_pos(&prc)
    @grid.each_with_index do |row, idx1|
      row.each_with_index do |card, idx2|
        prc.call(card,[idx1, idx2])
      end
    end
  end
end
