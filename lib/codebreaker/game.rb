module Codebreaker
  class Game
    attr_reader :code

    def initialize
      @code = Array.new(4) { rand(1..6) }.join
    end

    def submit_guess(guess)
      guess, code = guess.chars.zip(@code.chars)
        .select { |e| e[0] != e[1] }.transpose
      result = '' << '+' * (4 - code.size)
      guess.each do |e|
        digit_index = code.index(e)
        next unless digit_index
        result << '-'
        code.delete_at(digit_index)
      end
      result
    end

    def hint
      @hint ||= @code.chars.sample
    end
  end
end
