Dir["./lib/tic_tac_toe/*.rb"].each {|file| require file }
require 'logger'

module TicTacToe
  CIRCLE = "O"
  CROSS = "X"
  LOGGER = TicTacToe::Logging.create_logger()

  class << self
    def play
      GameRunner.new().run
    end
  end
end