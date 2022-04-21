module TicTacToe
  class Board
    def initialize()
      @positions = [
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil]
      ]

      LOGGER.debug("Initialized a board")
    end

    def place(symbol, position)
      @positions[position.x][position.y] = symbol
    end

    def symbol_at(position)
      @positions[position.x][position.y]
    end
  end
end