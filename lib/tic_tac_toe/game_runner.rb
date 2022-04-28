module TicTacToe
  class GameRunner
    ##
    # This class serves as a class running the game state machine
    # It asks for action to perform to the game state machine and
    # implements it with the help of interface it is passed
    def initialize(player1, player2, interface = CommandLineInterface, game = Game.new)
      @game = game
      @interface = interface
      @player1 = player1
      @player2 = player2
    end

    def run
      action_to_perform = @game.action_to_perform
      while !game_ending_action?(action_to_perform)
        print_action_errors_if_any(action_to_perform)

        case action_to_perform.name
        when :give_introduction
          @interface.print_introduction
          @game.start
        when :get_p1_name
          name = @player1.keep_or_change_name
          @game.accept_p1_name(name)
        when :get_p2_name
          name = @player2.keep_or_change_name
          @game.accept_p2_name(name)
        when :get_p1_move
          position = @player1.get_move(@game.board)
          @game.accept_p1_move(position)
        when :get_p2_move
          position = @player2.get_move(@game.board)
          @game.accept_p2_move(position)
        end

        action_to_perform = @game.action_to_perform
      end

      execute_game_end(action_to_perform)
    end

    def run_over_file
      action_to_perform = @game.action_to_perform
      # while !game_ending_action?(action_to_perform)
      #   print_action_errors_if_any(action_to_perform)

      #   case action_to_perform.name
      #   when :get_p1_name
      #     name = @player1.keep_or_change_name
      #     @game.accept_p1_name(name)
      #   when :get_p2_name
      #     name = @player2.keep_or_change_name
      #     @game.accept_p2_name(name)
      #   when :get_p1_move
      #     position = @player1.get_move(@game.board)
      #     @game.accept_p1_move(position)
      #   when :get_p2_move
      #     position = @player2.get_move(@game.board)
      #     @game.accept_p2_move(position)
      #   end

      #   action_to_perform = @game.action_to_perform
      # end

      execute_file_based_game_end(action_to_perform)
    end

    private

    def print_action_errors_if_any(action_to_perform)
      errors = action_to_perform.errors

      if errors.any?
        error_message = errors.join(', ')
        @interface.print_error(error_message)
      end
    end

    def game_ending_action?(action)
      action.name == :announce_victory || action.name == :announce_draw
    end

    def execute_game_end(game_ending_action)
      if game_ending_action.name == :announce_draw
        @interface.announce_draw(@game.board)
      end

      if game_ending_action.name == :announce_victory
        victorious_symbol = game_ending_action.details.fetch(:symbol)
        victor = (victorious_symbol == TicTacToe::CROSS ? @player1.name : @player2.name)
        @interface.announce_victory(@game.board, victor)
      end
    end

    def execute_file_based_game_end(game_ending_action)
      if game_ending_action.name == :announce_draw
        write_to_game_file("draw")
      end

      if game_ending_action.name == :announce_victory
        victorious_symbol = game_ending_action.details.fetch(:symbol)
        victor = (victorious_symbol == TicTacToe::CROSS ? @player1.name : @player2.name)
        write_to_game_file("win #{victor}")
      end
    end

    def write_to_game_file(string)
      File.open(game_file, "w") { |f| f.write(string)  }
    end

    def game_file
      "./tmp/#{game.id}.txt"
    end
  end
end