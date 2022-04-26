module TicTacToe
  class Path
    attr_reader :moves, :result

    def initialize(moves, board, symbol_to_place)
      CommandLineInterface.print_board(board)
      @moves = moves
      @board = board
      @symbol_to_place = symbol_to_place
      @result = board.result
    end

    def traverse_one_step
      puts "traversing a step"
      if @result == nil
        next_symbol_to_place = TicTacToe.the_other_symbol(@symbol_to_place)
        @board.available_positions.map do |position|
          puts "iterating for position #{position}"
          moves_traversed = @moves + [GameMove.new(position, @symbol_to_place)]
          copied_board = @board.make_a_copy
          copied_board.place(@symbol_to_place, position)
          self.class.new(moves_traversed,
            copied_board,
            next_symbol_to_place
          )
        end
      else
        []
      end
    end

    def first_move_position
      @moves[0] && @moves[0].position
    end

    def winning_for?(symbol)
      @result && @result[:verdict] == 'win' && @result[:victor] == symbol
    end

    def ==(other)
      other.class == self.class && other.moves == @moves
    end
  end

end