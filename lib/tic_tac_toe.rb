Dir["./lib/tic_tac_toe/*.rb"].each {|file| require file }
require 'logger'

##
# This is how the program is structured
#             TicTacToe-----------------
#                |                      |
#                V                      V
#            GameRunner       --------PlayerSetup
#            |       |        |                 |
#            V       |        |            -----------
#           Game     |        |            |         |
#            |       |        |            V         V
#            |       |        |    HumanPlayer   RandomBot
#            |       |        |      |               |
#            |       |        |      |               |
#            |       V        V      V               |
#            |      CommandLineInterface             |
#            |       |      |        |               |
#            |       |      V        V               |
#            |       |    STDOUT   STDIN             |
#            V       |                               |
#         Board<-----|-------------------------------
#            |       |
#            |       |
#            V       V
#             Position

# PlayerSetup: Module responsible for setting up players as bots or humans
# GameRunner : Gets the player setup and runs the game state machine and
#              interacts with user via CLI
# HumanPlayer: Represents human playing the game.
# RandomBot  : Bot which randomly gives the next valid move
# CommandLine: CLI to manage all terminal based IO
# Interface
# Game       : Represents game behavious as a state machine
# Board      : Represents tic tac toe board
# Position   : Value object to pass positions on tic tac toe board

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