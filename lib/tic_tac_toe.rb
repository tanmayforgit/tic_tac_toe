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
  end
end