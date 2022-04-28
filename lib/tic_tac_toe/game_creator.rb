module TicTacToe
  module GameCreator
    class << self
      def create
        game = Game.new()
        File.open("#{game_file_path}/#{game.id}", "wb")
        game
      end

      private

      def game_file_path
        "./tmp"
      end
    end
  end
end