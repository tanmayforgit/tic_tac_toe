module TicTacToe
  module PlayerSetup
    class << self
      def call(player_rank)
        CommandLineInterface.print(setup_intro_msg(player_rank))
        case STDIN.gets().strip
        when '1'
          HumanPlayer.new(player_rank)
        when '2'
          RandomBot.new()
        when '3'
          SmartBot.new(player_rank)
        else
          CommandLineInterface.print_error('Unknown response')
          call(player_rank)
        end
      end

      private

      def setup_intro_msg(player_rank)
        "Please enter player #{player_rank} type:\n1. Human  2. Random Bot 3. Smart Bot"
      end
    end
  end
end