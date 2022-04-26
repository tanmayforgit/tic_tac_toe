module TicTacToe
  ##
  # This class represents 3 * 3 board of a tic tac toe game
  class Board
    attr_reader :grid
    def initialize(grid = empty_grid)
      @grid = grid
    end

    def place(symbol, position)
      symbol_at_position = symbol_at(position)
      if symbol_at_position
        LOGGER.info("position #{position.inspect} is already occupied by symbol #{symbol_at_position}")
        raise InvalidPositionError.new(position, self)
      else
        @grid[position.y][position.x] = symbol
      end
    end

    def symbol_at(position)
      @grid[position.y][position.x]
    end

    def result
      [
        TicTacToe::CIRCLE,
        TicTacToe::CROSS
      ].each do |symbol|
        # checking for horizontal victory
        @grid.each do |row|
          return { verdict: 'win', victor: symbol } if row.all? { |s| s == symbol }
        end

        # checking for veritical victory
        @grid.transpose.each do |column|
          return { verdict: 'win', victor: symbol } if column.all? { |s| s == symbol }
        end
      end

      # Checking for diagonal victory
      symbol_at_center = symbol_at(Position.new(x: 1, y: 1))
      if symbol_at_center && diagonal_victory_for?(symbol_at_center)
        return { verdict: 'win', victor: symbol_at_center }
      end

      return { verdict: 'draw' } if all_positions_filled?

      nil
    end

    def available_positions
      all_positions.select { |position| symbol_at(position) == nil }
    end

    def to_s
      " ⎼⎼⎼⎼⎼ X ⎼⎼⎼⎼⎼▶\n"\
      "│\n"\
      "│   #{human_readable_row(0)}\n"\
      "│  -----------\n"\
      "Y   #{human_readable_row(1)}\n"\
      "│  -----------\n"\
      "│   #{human_readable_row(2)}\n"\
      "▼\n"
    end

    def ==(other)
      other.class == self.class && other.grid == self.grid
    end

    def make_a_copy
      duplicate_grid = @grid.map(&:dup)
      Board.new(duplicate_grid)
    end

    def possible_paths_with_verdicts(symbol_to_place)
      paths_after_a_step = Path.new([], self, symbol_to_place).traverse_one_step
      concluded_paths = []
      while paths_after_a_step.any?
        paths_after_two_setps = []
        paths_after_a_step.each do |path|
          if path.result
            concluded_paths << path
          else
            paths_after_two_setps << path.traverse_one_step
          end
          paths_after_a_step = paths_after_two_setps.flatten
        end
      end
      concluded_paths
    end

    def corner_positions
      [
        Position.new(x: 0, y: 0),
        Position.new(x: 0, y: 2),
        Position.new(x: 2, y: 0),
        Position.new(x: 2, y: 2),
      ]
    end

    def empty?
      @grid.flatten.all? {|place| place == nil }
    end

    class InvalidPositionError < StandardError
      attr_reader :position, :board
      def initialize(position, board)
        @position = position
        @board = board
      end
    end

    private

    def all_positions
      @all_positions ||= construct_all_positions
    end

    def construct_all_positions
      (0..2).map do |x|
        (0..2).map do |y|
          Position.new(x: x, y: y)
        end
      end.flatten
    end

    def human_readable_row(row_number)
      positions = (0..2).map {|x_co_ordinate| Position.new(x: x_co_ordinate, y: row_number) }
      positions.map { |position| human_readable_symbol_at(position) }.join(" | ")
    end

    def human_readable_symbol_at(position)
      symbol_at_position = symbol_at(position)
      if symbol_at_position
        symbol_at_position
      else
        " "
      end
    end

    def all_positions_filled?
      !(@grid.flatten.any? { |s| s == nil })
    end

    def diagonal_victory_for?(symbol)
      diagonals.each do |diagonal|
        return true if diagonal.all? { |s| s == symbol }
      end

      false
    end

    def diagonals
      [
        symbols_at_diagonal_with_0_0,
        symbols_at_diagonal_with_0_2
      ]
    end

    def symbols_at_diagonal_with_0_0
      [
        symbol_at(Position.new(x: 0, y: 0)),
        symbol_at(Position.new(x: 1, y: 1)),
        symbol_at(Position.new(x: 2, y: 2))
      ]
    end

    def symbols_at_diagonal_with_0_2
      [
        symbol_at(Position.new(x: 0, y: 2)),
        symbol_at(Position.new(x: 1, y: 1)),
        symbol_at(Position.new(x: 2, y: 0))
      ]
    end

    def empty_grid
      [
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil]
      ]
    end
  end
end