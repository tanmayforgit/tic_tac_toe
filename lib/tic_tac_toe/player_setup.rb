module TicTacToe
  module PlayerSetup
    class << self
      def call(player_rank)
        CommandLineInterface.print(setup_intro_msg)
        case STDIN.gets().strip
        when '1'
          HumanPlayer.new(player_rank)
        when '2'
          RandomBot.new()
        else
          CommandLineInterface.print_error('Unknown response')
          call(player_rank)
        end
      end

      private

      def setup_intro_msg
        "Please enter \n1. Human  2. Random Bot 3. Smart Bot"
      end
    end
  end
end