module TicTacToe
  class RandomBot
    attr_reader :name

    def initialize
      @name = nil
    end

    ##
    # Why are we letting bot change the name?
    # => We have a validation that player 1 name cannot
    #    equal player 2 name. In a rare scenario where someone
    #    decides to play two random bots with each other, we don't
    #    want both of them to generate same name by chance and land
    #    the game in infinite loop of random bot returning same name
    #    and game saying this name is invalid and asking the name again

    def keep_or_change_name
      @name = "Random bot #{rand(101..999)}"
    end

    def get_move(board)
      board.available_positions.sample
    end
  end
end