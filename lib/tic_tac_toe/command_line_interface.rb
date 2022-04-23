module TicTacToe
  class CommandLineInterface
    def initialize(game = Game.new)
      @game = game
    end

    def start
      action_to_perform = @game.action_to_perform

      while !game_ending_action?(action_to_perform)
        print_action_errors_if_any(action_to_perform)

        case action_to_perform.name
        when :give_introduction
          puts_introduction
          @game.start
        when :get_p1_name
          puts "Please enter p1 name"
          name = STDIN.gets().strip
          @game.accept_p1_name(name)
        when :get_p2_name
          puts "Please enter p2 name"
          name = STDIN.gets().strip
          @game.accept_p2_name(name)
        when :get_p1_move
          print_game_board
          puts "Please enter p1 move"
          position = get_position_from_command_line
          @game.accept_p1_move(position)
        when :get_p2_move
          print_game_board
          puts "Please enter p2 move"
          position = get_position_from_command_line
          @game.accept_p2_move(position)
        end

        action_to_perform = @game.action_to_perform
      end

      execute_game_end(action_to_perform)
    end

    private

    def print_game_board
      puts @game.board
    end

    def get_position_from_command_line
      user_position_input = STDIN.gets().strip

      Position.from_string(user_position_input)
    rescue Position::IncorrectFormat => e
      print_error('Please try again with correct format')
      get_position_from_command_line
    rescue Position::PositionOutOfBoard => e
      print_error('Please enter co-ordinates within the board')
      get_position_from_command_line
    end

    def print_action_errors_if_any(action_to_perform)
      errors = action_to_perform.errors

      if errors.any?
        error_message = errors.join(', ')
        print_error(error_message)
      end
    end

    def print_error(emsg)
      puts "\e[31m#{emsg}\e[0m"
    end

    def game_ending_action?(action)
      action.name == :announce_victory || action.name == :announce_draw
    end

    def execute_game_end(game_ending_action)
      if game_ending_action.name == :announce_draw
        puts_within_dashed_lines("Game was a draw")
      end

      if game_ending_action.name == :announce_victory
        victor = game_ending_action.details.fetch(:name)
        puts_within_dashed_lines("#{victor} won the game")
      end

      print_game_board
    end

    def puts_within_dashed_lines(string)
      puts(dashed_line)
      puts("\n#{string}\n")
      puts(dashed_line)
    end

    def puts_introduction
      puts_within_dashed_lines("Welcome to Command line Tic Tac Toe")

      introductory_board = Board.new()
      introductory_circle_position = Position.new(x: 1, y: 2)
      introductory_cross_position = Position.new(x: 2, y: 0)
      introductory_board.place(TicTacToe::CIRCLE, introductory_circle_position)
      introductory_board.place(TicTacToe::CROSS, introductory_cross_position)

      puts "Instructions:"
      puts "1. Player one always has X and player two always has O."
      puts "2. Game starts with accepting the player names."
      puts "3. Game then alteratively allows players to make their moves."
      puts "4. x axis increments towrds right and y axis increments towards downward direction starting from 0"
      puts "5. To place X like shown below a player will have to "\
           "enter 2,0 when his turn comes.\n"\
           "   To place O like shown below a player will have to"\
           "enter 1,2 when his turn comes.\n\n"
      puts introductory_board

    end

    def dashed_line
      "\n---------------------------------------\n"
    end
  end
end