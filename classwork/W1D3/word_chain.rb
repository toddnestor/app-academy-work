require "set"
require_relative 'node'

class WordChainer
  def initialize(dictionary_file_name = "dictionary.txt")
    populate_dictionary(dictionary_file_name)
  end

  def populate_dictionary(dictionary_file_name)
    @dictionary = Set.new(File.readlines(dictionary_file_name).map(&:chomp))
  end

  def adjacent_words(source)
    @dictionary.select { |word| word_is_adjacent?(source, word) && word != source }
  end

  def run(source, target)
    start_time = Time.now
    return nil if source.length != target.length
    @stack = [Node.new(source)]
    @all_seen_words = [source]

    until @stack.empty?
      anchor = @stack.shift

      if anchor.value == target
        puts trace_path(anchor)
        puts Time.now - start_time
        return
      end

      adjacent_words(anchor.value).each do |word|
        unless @all_seen_words.include?(word)
          @stack << Node.new(word, anchor)
          # sort_stack(target)
          @all_seen_words << word
        end
      end
    end

    puts "there is no path!"
  end

  def sort_stack(target)
    @stack.sort do |a, b|
      difference(a.value, target) <=> difference(b.value, target)
    end
  end

  def difference(word, target)
    different_chars = 0
    word.chars.each_with_index do |letter, idx|
      different_chars += 1 unless letter == target[idx]
    end
    different_chars
  end

  def trace_path(node)
    path = [node.value]
    until node.parent.nil?
      path.unshift(node.parent.value)
      node = node.parent
    end
    path
  end

  private
  def word_is_adjacent?(source, word)
    return false unless source.length == word.length
    difference(source, word) < 2
  end
end

word_chainer = WordChainer.new

word_chainer.run("duck", "ruby")
# puts word_chainer.difference("rube", "ruby")
# puts word_chainer.difference("rule", "ruby")
# puts word_chainer.difference("duff", "ruby")
