module TicTacToe
  RSpec.describe CommandLineInterface do
    before(:each) do
      # Setting the stdout to stringIO so that we can match the
      # expected output
      $stdout = StringIO.new
    end

    describe 'initialization' do
      let(:game) { Game.new() }
      subject { CommandLineInterface.new(game) }

      it 'initializes cli object' do
        expect(subject).to be_an_instance_of(CommandLineInterface)
      end
    end

    describe '#start' do
      # It should act as an interface to execute actions given by
      # the game until game gives announce_victory or announce_draw command

      let(:game) { Game.new() }
      let(:announce_draw_action) { double(name: :announce_draw, errors: []) }
      let(:announce_victory_action) { double(name: :announce_victory, errors: [], details: {name: 'p1'}) }
      let(:introduction_action) { double(name: :give_introduction, errors: []) }
      let(:get_p1_name_action) { double(name: :get_p1_name, errors: []) }
      let(:get_p2_name_action) { double(name: :get_p2_name, errors: []) }


      let(:cli) { CommandLineInterface.new(game) }

      it 'Acts as an interface for "announce_draw" game action' do
        allow(game).to receive(:action_to_perform).and_return(announce_draw_action)
        cli.start
        expect($stdout.string).to include("Game was a draw")
        expect($stdout.string).to include(game.board.to_s)
      end

      it 'Acts as an interface for "announce_victory" game action' do
        allow(game).to receive(:action_to_perform).and_return(announce_victory_action)
        cli.start
        expect($stdout.string).to include("p1 won the game")
        expect($stdout.string).to include(game.board.to_s)
      end

      # Note that game should always return victory or draw game action
      # at some point otherwise cli will never end
      it 'Acts as an interface for "give_introduction" game action and starts the game' do
        allow(game).to receive(:action_to_perform).and_return(introduction_action, announce_draw_action)
        expect(game).to receive(:start)
        cli.start
        expect($stdout.string).to include('Instructions')
      end

      it 'Acts as an interface for get_p1_name action and triggers accept_p1_name event on game' do
        allow(game).to receive(:action_to_perform).and_return(get_p1_name_action, announce_draw_action)
        allow(STDIN).to receive(:gets).and_return('awesome_player1')
        expect(game).to receive(:accept_p1_name).with('awesome_player1')
        cli.start
        expect($stdout.string).to include('Please enter p1 name')
      end

      it 'Acts as an interface for get_p2_name action and triggers accept_p2_name event on game' do
        allow(game).to receive(:action_to_perform).and_return(get_p2_name_action, announce_draw_action)
        allow(STDIN).to receive(:gets).and_return('awesome_player2')
        expect(game).to receive(:accept_p2_name).with('awesome_player2')
        cli.start
        expect($stdout.string).to include('Please enter p2 name')
      end

      context 'When game asks for accepting player moves actions' do
        let(:get_p1_move_action) { double(name: :get_p1_move, errors: []) }
        let(:get_p2_move_action) { double(name: :get_p2_move, errors: []) }

        context 'When position lies in a tic_tac_toe board' do
          it 'Acts as an interface for get_p1_move action and triggers accept_p1_move event on game' do
            allow(game).to receive(:action_to_perform).and_return(get_p1_move_action, announce_draw_action)
            allow(STDIN).to receive(:gets).and_return('1,2')
            expect(game).to receive(:accept_p1_move).with(Position.new(x:1, y:2))
            cli.start
            expect($stdout.string).to include('Please enter p1 move')
            expect($stdout.string).to include(game.board.to_s)
          end

          it 'Acts as an interface for get_p2_move action and triggers accept_p2_move event on game' do
            allow(game).to receive(:action_to_perform).and_return(get_p2_move_action, announce_draw_action)
            allow(STDIN).to receive(:gets).and_return('1,2')
            expect(game).to receive(:accept_p2_move).with(Position.new(x:1, y:2))
            cli.start
            expect($stdout.string).to include('Please enter p2 move')
            expect($stdout.string).to include(game.board.to_s)
          end
        end

        context 'When position lies out of tic_tac_toe board or format is incorrect' do
          it 'Asks for position again and again till valid position in entered' do
            allow(game).to receive(:action_to_perform).and_return(get_p1_move_action, announce_draw_action)
            allow(STDIN).to receive(:gets).and_return('','1 2', '1-2', '4,3', '-1, 2', '1,2')
            expect(game).to receive(:accept_p1_move).with(Position.new(x:1, y:2))
            cli.start
            expect($stdout.string).to include('Please enter p1 move')
            expect($stdout.string).to include('Please enter co-ordinates within the board')
            expect($stdout.string).to include('Please try again with correct format')
          end
        end
      end

      context 'Action to perform has errors' do
        let(:emsg1) { 'To err is human' }
        let(:emsg2) { 'To re err is stupid human' }
        let(:some_action_with_errors) { double(name: :some_action, errors: [emsg1, emsg2]) }
        it 'Prints any error if game action to implement has errors' do
          allow(game).to receive(:action_to_perform).and_return(some_action_with_errors, announce_draw_action)
          cli.start
          expect($stdout.string).to include(emsg1)
          expect($stdout.string).to include(emsg2)
        end
      end
    end
  end
end