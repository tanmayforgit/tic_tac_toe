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
      raise PositionOutOfBoard.new unless x.between?(0, 2)
      raise PositionOutOfBoard.new unless y.between?(0, 2)
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

        if StringHelper.is_a_integer?(string)
          # Attempt to create position from single integer like
          # phone dial
          # in these format this is how tic tac toe board looks like
          # 1 | 2 | 3
          # ----------
          # 4 | 5 | 6
          # ----------
          # 7 | 8 | 9

          int_position = string.to_i

          remainder_with_3 = int_position % 3
          # For x co ordinate, we want to convert 3,6,9 into 2
          # and 1,4,7 into 0 and 2,5,8 into 1
          x = (remainder_with_3 == 0 ? 2 : remainder_with_3 - 1)
          remainder_with_3 = int_position % 3
          y = (int_position - 1) / 3

          new(x: x, y: y)
        else
          # Attempt to create position from x,y co-ordinate
          # in these format this is how tic tac toe board looks like
          # 0,0 | 1,0 | 2,0
          # ----------------
          # 0,1 | 1,1 | 2,1
          # ----------------
          # 0,2 | 1,2 | 2,2

          comma_separated_strings = string.split(",")
          raise IncorrectFormat.new() unless comma_separated_strings.size == 2

          x, y = *comma_separated_strings
          new(x: x, y: y)
        end
      end
    end
  end
end
