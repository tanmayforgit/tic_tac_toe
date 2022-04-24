module TicTacToe
  module CommandLineInterface
   class << self
      def print_board(board)
        puts board
      end

      def print_error(emsg)
        puts "\e[31m#{emsg}\e[0m"
      end

      def print_introduction
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

      def get_name(name_holder)
        puts("Please enter #{name_holder} name")
        STDIN.gets.strip()
      end

      def get_move(board, mover_name)
        puts board
        puts("#{mover_name}, please enter your move")
        get_position_from_command_line
      end

      def announce_draw(board)
        puts_within_dashed_lines('Game was a draw')
        puts board
      end

      def announce_victory(board, victor_name)
        puts_within_dashed_lines("#{victor_name} won the game")
        puts board
      end

      private

      def get_position_from_command_line
        user_position_input = STDIN.gets().strip
        Position.from_string(user_position_input)
      rescue Position::IncorrectFormat => e
        print_error('Please try again with correct format')
        get_position_from_command_line
      rescue Position::PositionOutOfBoard => e
        print_error('Please enter co-ordinates within the board')
        get_position_from_command_line
      rescue Position::EmptyString => e
        print_error('Empty move is invalid')
        get_position_from_command_line
      end

      def dashed_line
        "\n---------------------------------------\n"
      end

      def puts_within_dashed_lines(string)
        puts(dashed_line)
        puts("\n#{string}\n")
        puts(dashed_line)
      end

    end
  end
end