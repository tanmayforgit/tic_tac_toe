module TicTacToe
  class RandomBot
    include BotNameHelper

    attr_reader :name

    def initialize
      @name = nil
    end

    def get_move(board)
      board.available_positions.sample
    end
  end
end
