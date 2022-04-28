module TicTacToe
  RSpec.describe HumanPlayer do
    let(:cli) { double(get_name: 'Mr right', get_move: Position.new(x: 2, y: 0)) }
    let(:human_player) { HumanPlayer.new(1, cli) }

    describe '#keep_or_change_name' do
      subject { human_player.keep_or_change_name }

      it 'keeps new or changes the name with the help of cli' do
        expect(subject).to eq('Mr right')
        expect(human_player.name).to eq('Mr right')
      end
    end

    describe '#get_move' do
      let(:board) { Board.new }
      subject { human_player.get_move(board) }
      it 'Gets the move with the help of cli' do
        expect(subject).to eq(cli.get_move)
      end
    end

    describe 'check_and_execute_command' do
      let(:game) { Game.new() }
      let(:player1) { HumanPlayer.new(1, game.id) }
      let(:player2) { HumanPlayer.new(2, game.id) }
      it 'gets command from game file and implements draw action' do
        board = Board.new
        draw_game_state = {
          "action" => "draw",
          "board" => board
        }
        allow(File).to receive(:binread).with("./tmp/#{game.id}") { Marshal.dump(draw_game_state) }
        expect(CommandLineInterface).to receive(:announce_draw)
        player1.check_and_execute_commands()
      end

      describe "move_commands" do
        context "action is for the player" do
          let(:cli) { CommandLineInterface }
          it 'gets command from game file and implements make move action' do
            board = Board.new
            draw_game_state = {
              "action" => "draw",
              "board" => board
            }

            make_p1_move_state = {
              "action" => "make_p1_move",
              "board" => board
            }
            allow(File).to receive(:binread).with("./tmp/#{game.id}").and_return(Marshal.dump(make_p1_move_state) ,Marshal.dump(draw_game_state))
            expect(cli).to receive(:get_move).with(board, "tanmay").and_return(Position.new(x: 1, y: 1))
            player1.check_and_execute_commands()

            game_state = Marshal.load(File.binread("./tmp/#{@game_id}"))
            expect(game_state["action"]).to eq("accept_p1_move")
            expect(game_state["move"]).to eq(Position.new(x: 1, y: 1))
          end
        end

        context "action is not for the player" do
        end
      end
    end
  end
end