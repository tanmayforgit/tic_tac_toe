module TicTacToe
  class HumanPlayer
    attr_reader :name

    def initialize(player_rank, game_id, interface = CommandLineInterface)
      @name = nil
      @player_rank = player_rank
      @interface = interface
      @game_id = game_id
    end

    def check_and_execute_commands
      board, action = *get_board_and_action()
      while !end_action?(action)
        if action_for_me?(action)
          execute_action(action)
        end

        sleep(1)
      end

      execute_action(action, board)
    end

    def execute_action(action, board)
      case action
      when "draw"
        @interface.announce_draw(board)
      end
    end

    def keep_or_change_name
      @name = @interface.get_name("Player #{@player_rank}")
    end

    def get_move(board)
      @interface.get_move(board, @name)
    end

    private

    def action_for_me?(action)
      action == "make_p1_move" || action == "get_p1_name"
    end

    def end_action?(action)
      action == "draw" || action == "announce_win"
    end

    def get_board_and_action()
      game_state = Marshal.load(File.binread("./tmp/#{@game_id}"))

      action = game_state["action"]
      board = game_state["board"]
      [board, action]
    end
  end
end