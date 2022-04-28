module TicTacToe
  RSpec.describe GameRunner do

    # describe "#run" do
    #   # It should act as an interface to execute actions given by
    #   # the game until game gives announce_victory or announce_draw command

    #   let(:game) { Game.new() }
    #   let(:introduction_action) { double(name: :give_introduction, errors: []) }
    #   let(:get_p1_name_action) { double(name: :get_p1_name, errors: []) }
    #   let(:get_p2_name_action) { double(name: :get_p2_name, errors: []) }
    #   let(:get_p1_move_action) { double(name: :get_p1_move, errors: []) }
    #   let(:get_p2_move_action) { double(name: :get_p2_move, errors: []) }
    #   let(:announce_draw_action) { double(name: :announce_draw, errors: []) }
    #   let(:announce_victory_action) { double(name: :announce_victory, errors: [], details: {symbol: TicTacToe::CIRCLE}) }
    #   let(:player1) { double(keep_or_change_name: "p1", name: "p1", get_move: Position.new(x: 1, y: 0), display_draw: true) }
    #   let(:player2) { double(keep_or_change_name: "p2", name: "p2", get_move: Position.new(x: 1, y: 2), display_draw: true) }

    #   let(:interface) do
    #     double(
    #       print_introduction: true,
    #       get_name: "name",
    #       get_move: Position.new(x: 1, y: 1),
    #       print_error: true,
    #       print_board: true,
    #       announce_draw: true,
    #       announce_victory: true,
    #       accept_create_or_join_game: true,
    #       # list_game: true
    #       accept_game_id: true
    #     )
    #   end

    #   let(:game_runner) { GameRunner.new(player1, player2, interface, game) }
    #   # Game run will never end unless game gives draw or victory actions. Hence game should
    #   # always give one of those actions
    #   it "Runs draw action" do
    #     allow(game).to receive(:action_to_perform).and_return(announce_draw_action)
    #     expect(interface).to receive(:announce_draw).with(game.board)
    #     game_runner.run
    #   end

    #   it "Runs introduction_action" do
    #     allow(game).to receive(:action_to_perform).and_return(introduction_action, announce_draw_action)
    #     expect(game).to receive(:start)
    #     expect(interface).to receive(:print_introduction)
    #     game_runner.run
    #   end

    #   it "Runs get_p1_name action" do
    #     allow(game).to receive(:action_to_perform).and_return(get_p1_name_action, announce_draw_action)
    #     expect(player1).to receive(:keep_or_change_name)
    #     expect(game).to receive(:accept_p1_name).with(player1.name) # We have mocked get_name interface to return "name"
    #     game_runner.run
    #   end

    #   it "Runs get_p2_name action" do
    #     allow(game).to receive(:action_to_perform).and_return(get_p2_name_action, announce_draw_action)
    #     expect(player2).to receive(:keep_or_change_name)
    #     expect(game).to receive(:accept_p2_name).with('p2') # We have mocked get_name interface to return "name"
    #     game_runner.run
    #   end

    #   it "Runs get_p1_move action" do
    #     allow(game).to receive(:action_to_perform).and_return(get_p1_move_action, announce_draw_action)
    #     expect(player1).to receive(:get_move).with(game.board)
    #     expect(game).to receive(:accept_p1_move).with(player1.get_move)
    #     game_runner.run
    #   end

    #   it "Runs get_p2_move action" do
    #     allow(game).to receive(:action_to_perform).and_return(get_p2_move_action, announce_draw_action)
    #     expect(player2).to receive(:get_move).with(game.board)
    #     expect(game).to receive(:accept_p2_move).with(player2.get_move)
    #     game_runner.run
    #   end

    #   it "Runs announce_victory action" do
    #     allow(game).to receive(:action_to_perform).and_return(announce_victory_action)

    #     # announce victory action declares O as the winner. Circle means player 2
    #     expect(interface).to receive(:announce_victory).with(game.board, player2.name)

    #     game_runner.run
    #   end
    # end

    describe 'run_over_file' do
      let(:game) { Game.new() }
      let(:introduction_action) { double(name: :give_introduction, errors: []) }
      let(:get_p1_name_action) { double(name: :get_p1_name, errors: []) }
      let(:get_p2_name_action) { double(name: :get_p2_name, errors: []) }
      let(:get_p1_move_action) { double(name: :get_p1_move, errors: []) }
      let(:get_p2_move_action) { double(name: :get_p2_move, errors: []) }
      let(:announce_draw_action) { double(name: :announce_draw, errors: []) }
      let(:announce_victory_action) { double(name: :announce_victory, errors: [], details: {symbol: TicTacToe::CIRCLE}) }
      let(:player1) { double(keep_or_change_name: "p1", name: "p1", get_move: Position.new(x: 1, y: 0), display_draw: true) }
      let(:player2) { double(keep_or_change_name: "p2", name: "p2", get_move: Position.new(x: 1, y: 2), display_draw: true) }

      it "Runs draw action" do
        allow(game).to receive(:action_to_perform).and_return(announce_draw_action)
        expect(player1).to receive(:announce_draw).with(game.board)
        expect(player2).to receive(:announce_draw).with(game.board)
        game_runner.run
      end

    end
  end
end