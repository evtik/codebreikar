require_relative 'game'
require_relative 'reporter'
require_relative 'saver'

module Codebreaker
  class Console
    ATTEMPTS = 10

    attr_reader :guesses, :game

    def start
      puts 'Welcome to Codebreaker!'
      init_game
      loop do
        do_action parse_user_command
        next unless @attempts.zero? || @game_over
        unless @guesses.empty?
          show_report
          save_results if yes_no('Save results? y/n: ')
        end
        yes_no('Play again? y/n: ') ? init_game : exit
      end
    end

    def init_game
      puts 'New game started'
      @game = Game.new
      @attempts = ATTEMPTS
      @game_over = false
      @guesses = []
      @report = nil
    end

    def quit_game
      @game_over = true
    end

    def do_action(args)
      args.is_a?(Array) ? send(args.shift, *args) : send(args)
    end

    def parse_user_command
      print "Enter a four-digit guess or 'h' - for hint, 'q' - to quit: "
      case input = gets.chomp
      when 'h' then :show_hint
      when 'q' then :quit_game
      when /\A[1-6]{4}\z/ then [:submit_input, input]
      else :invalid_input
      end
    end

    def invalid_input
      puts 'Invalid input'
    end

    def submit_input(input)
      if input == @game.code
        @guesses << [input, '++++']
        @game_over = true
      else
        @attempts -= 1
        feedback = @game.submit_guess(input)
        @guesses << [input, feedback]
        puts "Attempts remaining: #{@attempts}, guess feedback: #{feedback}"
        @game_over = true if @attempts.zero?
      end
    end

    def show_hint
      puts "The code has a #{@game.hint} at an arbitrary position"
    end

    def show_report
      @reporter ||= Reporter.new
      puts @report ||= @reporter.create_report(@guesses, @game.code)
    end

    def save_results
      @saver ||= Saver.new
      name = parse_user_name
      @saver.save_game(name, @report)
    end

    def parse_user_name
      loop do
        print('Enter your name (letters and digits, no spaces): ')
        input = gets.chomp
        return input.strip if input =~ /\A\s*\w+\s*\z/
        invalid_input
      end
    end

    def yes_no(prompt)
      loop do
        print(prompt)
        case gets.chomp
        when 'y' then return true
        when 'n' then return false
        else invalid_input
        end
      end
    end
  end
end
