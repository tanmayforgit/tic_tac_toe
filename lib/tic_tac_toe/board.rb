module TicTacToe
  class Board
    def initialize()
      @grid = [
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil]
      ]
    end

    def place(symbol, position)
      symbol_at_position = symbol_at(position)
      if symbol_at_position
        LOGGER.info("position #{position.inspect} is already occupied by symbol #{symbol_at_position}")
        raise InvalidPositionError.new(position, self)
      else
        @grid[position.x][position.y] = symbol
      end
    end

    def symbol_at(position)
      @grid[position.x][position.y]
    end

    class InvalidPositionError < StandardError
      attr_reader :position, :board
      def initialize(position, board)
        @position = position
        @board = board
      end
    end
  end
end