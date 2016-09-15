require_relative 'node'

class Change
  attr_reader :amount, :coins, :coin_count

  def initialize(amount, coins)
    @amount = amount
    @coins = coins
    @coin_count = Hash.new(0)
    @stack = [Node.new(@amount)]
  end

  def collect_coins(node)
      return @coin_count if node.parent.nil?
      @coin_count[node.parent.value - node.value] += 1
      collect_coins(node.parent)
  end

  def make_better_change_old
    until stack.empty?
      anchor = stack.shift
      @coins.each do |value|
        new_value = anchor.value - value
        new_node = Node.new(new_value, anchor)

        return collect_coins(new_node) if new_value == 0

        if value < anchor.value
          @stack.push(new_node)
        end
      end
    end
  end

  def make_better_change
    return nil if @stack.empty?

    anchor = @stack.shift

    @coins.each do |value|
      new_value = anchor.value - value
      new_node = Node.new(new_value, anchor)

      return collect_coins(new_node) if new_value == 0

      if value < anchor.value
        @stack.push(new_node)
      end
    end

    make_better_change
  end

  def greedy_change(amount = nil, coins = nil)
    amount = @amount if amount.nil?
    coins = @coins.dup if coins.nil?
    return {} if amount <= 0
    coins_count = {}
    coins_count[coins.max] = amount / coins.max
    remainder = amount % coins.max
    coins.delete(coins.max)
    coins_count.merge(greedy_change(remainder, coins))
  end
end

change = Change.new(24, [10,7,1])
p change.make_better_change
p change.greedy_change
