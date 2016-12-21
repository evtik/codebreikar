module Codebreaker
  class Reporter
    def create_report(guesses, code)
      render_title(code) +
        render_headers +
        render_guesses(guesses) +
        render_footer(guesses.last)
    end

    def render_line
      '-' * 36 + "\n"
    end

    def render_title(code)
      render_line + "  Your results for code #{code} are:\n"
    end

    def render_headers
      render_line + "  Attempt #  |  Guess  |  Feedback\n" + render_line
    end

    def render_guesses(guesses)
      result = ''
      guesses.each_with_index do |g, i|
        gap = i < 9 ? '   ' : '  '
        result << gap + (i + 1).to_s + ' ' * 12 + g[0] + ' ' * 6 + g[1] + "\n"
      end
      result
    end

    def render_footer(guess)
      render_line + '  ' +
        (guess.last == '++++' ? 'You won!' : 'You lost!') + "\n" +
        render_line
    end
  end
end
