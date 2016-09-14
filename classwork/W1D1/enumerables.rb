class Array
  def my_each(&blk)
    self.length.times do |num|
      blk.call self[num]
    end

    self
  end

  def my_select(&blk)
    output = []

    self.my_each {|item| output << item if blk.call(item)}

    output
  end

  def my_reject(&blk)
    output = []

    self.my_each {|item| output << item unless blk.call(item)}

    output
  end

  def my_any?(&blk)
    self.my_each do |item|
      return true if blk.call(item)
    end

    false
  end

  def my_all?(&blk)
    self.my_each do |item|
      return false unless blk.call(item)
    end

    true
  end

  def my_flatten
    output = []

    self.my_each do |item|
      if item.is_a?(Array)
        item.my_flatten.my_each do |item2|
          output << item2
        end
      else
        output << item
      end
    end

    output
  end

  def my_zip(*args)
    output = []

    self.each.with_index do |num, i|
      zipped_array = [num]
      args.my_each do |arr|
        zipped_array << arr[i]
      end

      output << zipped_array
    end

    output
  end

  def my_rotate(amount = 1)
    if amount > 0
      amount.times {self << self.shift}
    else
      amount.abs.times {self.unshift(self.pop)}
    end

    self
  end

  def my_join(separator = "")
    output = ""

    self.each_with_index do |letter, i|
      output << letter
      output << separator unless i == self.length - 1
    end

    output
  end

  def my_reverse
    output = []

    (self.length - 1).downto(0) {|i| output << self[i]}

    output
  end

end
