module TicTacToe
  class GameRunner
    def initialize(game = Game.new, interface)
      @game = game
      @interface = interface
      @p1_name = nil
      @p2_name = nil
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
          name = @interface.get_name("player 1")
          @p1_name = name
          @game.accept_p1_name(name)
        when :get_p2_name
          name = @interface.get_name("player 2")
          @p2_name = name
          @game.accept_p2_name(name)
        when :get_p1_move
          position = @interface.get_move(@game.board)
          @game.accept_p1_move(position)
        when :get_p2_move
          position = @interface.get_move(@game.board)
          @game.accept_p2_move(position)
        end

        action_to_perform = @game.action_to_perform
      end

      execute_game_end(action_to_perform)
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
        @interface.announce_draw
      end

      if game_ending_action.name == :announce_victory
        victorious_symbol = game_ending_action.details.fetch(:symbol)
        victor = (victorious_symbol == TicTacToe::CROSS ? @p1_name : @p2_name)
        @interface.announce_victory(victor)
      end

      @interface.print_board(@game.board)
    end
  end
end