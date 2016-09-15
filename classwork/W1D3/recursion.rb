def range(start_num, end_num)
  return [] if end_num < start_num
  return [start_num] if start_num == end_num
  [start_num] + range(start_num + 1, end_num)
end

def sum_of_array_recursive(arr)
  return 0 if arr.length < 1
  return arr.first if arr.length == 1
  arr.first + sum_of_array_recursive(arr.drop(1))
end

def sum_of_array_iteratively(arr)
  arr.inject(:+)
end

def exp(num, e)
  return nil if e < 0
  return 1 if e == 0
  num * exp(num, e - 1)
end

def exp2(num, e)
  return 1 if e == 0
  # return num if e == 1
  if e.even?
    exp2(num, e / 2 ) ** 2
  else
    num * exp2(num, (e - 1))
  end
end

# p exp2(2, 0)
# p exp2(2, 1)
# p exp2(2, 5)
# p exp2(2, 255)

class Array
  def deep_dup_less_recursive
    dup = []
    self.each do |el|
      if el.is_a?(Array)
        dup << el.deep_dup_less_recursive
      else
        dup << el
      end
    end
    dup
  end

  def deep_dup
    return self if self.length == 1
    [first_dup_item] + self[1..-1].deep_dup
  end

  def first_dup_item
    self.first.is_a?(Array) ? self.first.deep_dup : self.first
  end
end

# some_arr = Array.new(5) {(1..5).to_a}
#
# p some_arr
#
# new_arr = some_arr.deep_dup
# # new_arr = some_arr.dup
#
# p new_arr
#
# puts
# puts

# some_arr[0][0] = "tree"
#
# p some_arr
# p new_arr

def fibonacci(n)
  return [] if n < 1
  return [1] if n == 1
  return [1,1] if n == 2

  previous_arr = fibonacci(n-1)
  new_number = previous_arr[-1] + previous_arr[-2]
  previous_arr + [new_number]
end

# p fibonacci(0)
# p fibonacci(1)
# p fibonacci(2)
# p fibonacci(3)
# p fibonacci(5)
# p fibonacci(12)

def bsearch(arr, target)
  return nil if arr.length < 1
  # return nil if target > arr.max || target < arr.min
  compare_index = arr.length / 2
  match = target <=> arr[compare_index]
  case match
  when -1
    bsearch(arr.take(compare_index), target)
  when 0
    compare_index
  else
    result = bsearch(arr.drop(compare_index+1), target)
    return nil if result.nil?
    result + compare_index + 1
  end
end

# array = (1..1000).to_a
# # array = [11]
# p bsearch(array, 1)
# p bsearch(array, 27)
# p bsearch(array, 1001)
# p bsearch(array, 799)
# p bsearch(array, 500)
def merge_sort(array)
  return array if array.length <= 1

  first_half = array.take(array.length / 2)
  second_half = array.drop(first_half.length)

  merge( merge_sort(first_half), merge_sort(second_half) )
end

def merge(array1, array2)
  return array1 if array2.empty?
  return array2 if array1.empty?

  case array1.first <=> array2.first
  when -1
    [array1.shift] + merge(array1, array2)
  else
    [array2.shift] + merge(array1, array2)
  end
end

# p merge_sort((1..10).to_a.shuffle)
class Array
  def subsets
    return [[]] if self.empty?
    return [[], self.dup] if self.length == 1

    self.take(self.length - 1).subsets.generate_sets_new(self.last)
  end

  def generate_sets(num)
    self.inject(self.dup) do |results, el|
      results << (el + [num])
    end
  end

  def generate_sets_new(num)
    return [self.first, self.first + [num]] if self.length <= 1
    self.take(1).generate_sets_new(num) + self.drop(1).generate_sets_new(num)
  end
end

# array = [1,2]
# p array.subsets

def greedy_change(amount, coins)
  return {} if amount <= 0
  coins_count = {}
  coins_count[coins.max] = amount / coins.max
  remainder = amount % coins.max
  coins.delete(coins.max)
  coins_count.merge(greedy_change(remainder, coins))
end

# coins = [25, 10, 5, 1]
# p greedy_change(99, coins)

def make_better_change(amount, coins)
  stack = [amount]
  until stack.empty?
    coins.each do |coin|
      break if amount - coin == 0
      stack << amount - coin if amount >= coin
      make_better_change(amount-coin, coins)
    end
  end
end
