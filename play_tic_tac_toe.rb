require './lib/tic_tac_toe'
game = TicTacToe::Game.new()
cli = TicTacToe::CommandLineInterface.new(game)
cli.start