## This class serves as a value object for depicting position
module TicTacToe
  class Position
    attr_reader :x, :y

    ## Creates a position object
    # will raise InvalidPositionError if position is outside of standard tic tac toe
    # board size of 3 i.e. x and y should always be between 0 and 2
    def initialize(x:, y:)
      x = x.to_i
      y = y.to_i
      raise InvalidPositionError.new unless x.between?(0,2)
      raise InvalidPositionError.new unless y.between?(0,2)
      @x = x.to_i
      @y = y.to_i
    end

    def inspect
      "(#{@x}, #{@y})"
    end

    class InvalidPositionError < StandardError; end
  end
end