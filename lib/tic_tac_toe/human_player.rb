module TicTacToe
  class HumanPlayer
    attr_reader :name

    def initialize(player_rank, interface = CommandLineInterface)
      @name = nil
      @player_rank = player_rank
      @interface = interface
    end

    def keep_or_change_name
      @name = @interface.get_name("Player #{@player_rank}")
    end

    def get_move(board)
      @interface.get_move(board, @name)
    end
  end
end