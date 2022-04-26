module TicTacToe
  class SmartBot
    include BotNameHelper
    attr_reader :name
    def initialize(rank)
      @name = nil
      @my_symbol = TicTacToe.get_symbol(rank)
      @opponent_symbol = TicTacToe.the_other_symbol(@my_symbol)
    end

    def get_move(board)
      my_one_step_paths = Path.new([], board, @my_symbol).traverse_one_step
      winning_path = my_one_step_paths.detect {|p| p.winning_for?(@my_symbol) }

      return winning_path.first_move_position if winning_path

      opponent_one_step_paths = Path.new([], board, @opponent_symbol).traverse_one_step
      opponent_winning_path = opponent_one_step_paths.detect { |p| p.winning_for?(@opponent_symbol)}

      # If I can't win then let the opponent not win in the next step
      return opponent_winning_path.first_move_position if opponent_winning_path

      # Tic tac toe has higher chance of winning if first move is corner move
      return board.corner_positions.sample if board.empty?

      # Well game is at least not winning and loosing in next move.
      # Lets take a random step

      # TODO: This behaviour can be improved in the future by traversing
      # at more than one depth and designing a ranking system for
      # the path and choosing the best path possible


      return board.available_positions.sample
    end
  end
end