Dir["./lib/tic_tac_toe/*.rb"].each {|file| require file }
require 'logger'

module TicTacToe
  CIRCLE = "O"
  CROSS = "X"
  LOGGER = TicTacToe::Logging.create_logger()


  class << self
    def play
      player1 = PlayerSetup.call(1)
      player2 = PlayerSetup.call(2)
      GameRunner.new(player1, player2).run
    end

    def the_other_symbol(symbol)
      symbol == CROSS ? CIRCLE : CROSS
    end

    def get_symbol(rank)
      rank == 1 ? CROSS : CIRCLE
    end
  end
end