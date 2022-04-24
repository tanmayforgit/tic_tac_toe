module TicTacToe
  RSpec.describe GameRunner do
    describe "#run" do
      # It should act as an interface to execute actions given by
      # the game until game gives announce_victory or announce_draw command

      let(:game) { Game.new() }
      let(:introduction_action) { double(name: :give_introduction, errors: []) }
      let(:get_p1_action) { double(name: :get_p1, errors: []) }
      let(:get_p2_action) { double(name: :get_p2, errors: []) }
      let(:get_p1_move_action) { double(name: :get_p1_move, errors: []) }
      let(:get_p2_move_action) { double(name: :get_p2_move, errors: []) }
      let(:announce_draw_action) { double(name: :announce_draw, errors: []) }
      let(:announce_victory_action) { double(name: :announce_victory, errors: [], details: {symbol: TicTacToe::CIRCLE}) }

      let(:interface) do
        double(
          print_introduction: true,
          get_name: "name",
          get_move: Position.new(x: 1, y: 1),
          print_error: true,
          print_board: true,
          announce_draw: true,
          announce_victory: true
        )
      end

      let(:game_runner) { GameRunner.new(interface, game) }
      # Game run will never end unless game gives draw or victory actions. Hence game should
      # always give one of those actions
      it "Runs draw action" do
        allow(game).to receive(:action_to_perform).and_return(announce_draw_action)
        expect(interface).to receive(:announce_draw).with(game.board)
        game_runner.run
      end

      it "Runs introduction_action" do
        allow(game).to receive(:action_to_perform).and_return(introduction_action, announce_draw_action)
        expect(game).to receive(:start)
        expect(interface).to receive(:print_introduction)
        game_runner.run
      end

      it "Runs get_p1 action" do
        allow(game).to receive(:action_to_perform).and_return(get_p1_action, announce_draw_action)
        expect(interface).to receive(:get_name).with("player 1")
        expect(game).to receive(:accept_p1_name).with("name") # We have mocked get_name interface to return "name"
        game_runner.run
      end

      it "Runs get_p2 action" do
        allow(game).to receive(:action_to_perform).and_return(get_p2_action, announce_draw_action)
        expect(interface).to receive(:get_name).with("player 2")
        expect(game).to receive(:accept_p2_name).with("name") # We have mocked get_name interface to return "name"
        game_runner.run
      end

      it "Runs get_p1_move action" do
        allow(game).to receive(:action_to_perform).and_return(get_p1_action, get_p1_move_action, announce_draw_action)
        allow(game).to receive(:accept_p1_name)
        allow(interface).to receive(:get_name).and_return('p1_name')
        expect(interface).to receive(:get_move).with(game.board, 'p1_name')
        expect(game).to receive(:accept_p1_move).with(Position.new(x: 1, y: 1)) # We have mocked get_move interface to return Position.new(x: 1, y: 1)"
        game_runner.run
      end

      it "Runs get_p2_move action" do
        allow(game).to receive(:action_to_perform).and_return(get_p2_action, get_p2_move_action, announce_draw_action)
        allow(game).to receive(:accept_p2_name)
        allow(interface).to receive(:get_name).and_return('p2_name')
        expect(interface).to receive(:get_move).with(game.board, 'p2_name')
        expect(game).to receive(:accept_p2_move).with(Position.new(x: 1, y: 1)) # We have mocked get_move interface to return Position.new(x: 1, y: 1)"
        game_runner.run
      end

      it "Runs announce_victory action" do
        allow(game).to receive(:action_to_perform).and_return(get_p2_action, announce_victory_action)
        allow(interface).to receive(:get_name).with("player 2").and_return("p2_name")
        allow(game).to receive(:accept_p2_name)

        # announce victory action declares O as the winner. Circle means player 2
        expect(interface).to receive(:announce_victory).with(game.board, "p2_name")

        game_runner.run
      end
    end
  end
end