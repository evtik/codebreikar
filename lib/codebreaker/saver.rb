module Codebreaker
  class Saver
    def save_game(name, game_data)
      File.write("#{name}.txt", game_data)
      puts "File #{name}.txt saved!"
    end
  end
end
