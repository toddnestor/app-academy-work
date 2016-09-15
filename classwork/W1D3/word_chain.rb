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
    words = []

    source.chars.each_with_index do |letter, i|
      ('a'..'z').to_a.reject {|char| char == letter}.each do |char|
        new_word = source.dup
        new_word[i] = char
        words << new_word if @dictionary.include?(new_word)
      end
    end

    words
  end

  def run(source, target)
    start_time = Time.now
    if source.length != target.length
      puts "there can be no path between words of different sizes!"
      return
    end
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
end
if __FILE__ == $PROGRAM_NAME
  word_chainer = WordChainer.new
  word1 = ARGV[0].nil? ? "duck" : ARGV[0]
  word2 = ARGV[1].nil? ? "ruby" : ARGV[1]
  word_chainer.run(word1, word2)
end
