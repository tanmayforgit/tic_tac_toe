## This class serves as a value object for depicting position
module TicTacToe
  class Position
    attr_reader :x, :y

    ## Creates a position object
    # will raise PositionOutOfBoard if position is outside of standard tic tac toe
    # board size of 3 i.e. x and y should always be between 0 and 2
    def initialize(x:, y:)
      x = x.to_i
      y = y.to_i
      raise PositionOutOfBoard.new unless x.between?(0,2)
      raise PositionOutOfBoard.new unless y.between?(0,2)
      @x = x.to_i
      @y = y.to_i
    end

    def inspect
      "(#{@x}, #{@y})"
    end

    def to_s
      "(#{@x}, #{@y})"
    end

    def ==(other)
      other.class == self.class && other.x == @x && other.y == @y
    end

    class PositionOutOfBoard < StandardError; end
    class IncorrectFormat < StandardError; end
    class EmptyString < StandardError; end

    class << self
      def from_string(string)
        raise IncorrectFormat.new() unless string.is_a?(String)

        raise EmptyString.new() unless string.length > 0

        comma_separated_strings = string.split(',')
        raise IncorrectFormat.new() unless comma_separated_strings.size == 2

        x, y = *comma_separated_strings
        new(x: x, y: y)
      end
    end
  end
end