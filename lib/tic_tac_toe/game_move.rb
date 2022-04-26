module TicTacToe
  class GameMove
    attr_reader :position, :symbol
    def initialize(position, symbol)
      @position = position
      @symbol = symbol
    end

    def ==(other)
      other.class == self.class && other.position == @position && other.symbol == @symbol
    end
  end
end