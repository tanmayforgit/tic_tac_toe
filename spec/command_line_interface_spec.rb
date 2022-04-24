module TicTacToe
  RSpec.describe CommandLineInterface do
    before(:each) do
      # Setting the stdout to stringIO so that we can match the
      # expected output
      $stdout = StringIO.new
    end

    after(:each) do
      $stdout = STDOUT
    end

    describe "#print_error" do
      let(:emsg) { 'To err is human' }
      it "prints error" do
        CommandLineInterface.print_error(emsg)
        expect($stdout.string).to include(emsg)
      end
    end

    describe "#print_introduction" do
      it "prints introduction to command line" do
        CommandLineInterface.print_introduction
        expect($stdout.string).to include('Instructions')
      end
    end

    describe "#get_name" do
      subject { CommandLineInterface.get_name("Player 1") }
      it "asks for and accepts name from command line" do
        allow(STDIN).to receive(:gets).and_return('Ticker Tacker')
        expect(subject).to eq('Ticker Tacker')
        expect($stdout.string).to include('Please enter Player 1 name')
      end
    end

    describe "#get_move" do
      let(:board) { Board.new() }
      subject { CommandLineInterface.get_move(board, 'Tick Tack Toer') }

      context 'When position lies in a tic_tac_toe board' do
        it 'It asks for and returns position' do
          allow(STDIN).to receive(:gets).and_return("1,2")
          expect(subject).to eq(Position.new(x: 1, y: 2))
          expect($stdout.string).to include('Tick Tack Toer, please enter your move')
          expect($stdout.string).to include(board.to_s)
        end
      end

      context 'When position lies out of tic_tac_toe board or format is incorrect' do
        it 'Asks for position again and again till valid position in entered' do
          allow(STDIN).to receive(:gets).and_return('','1 2', '1-2', '4,3', '-1, 2', '1,2')
          expect(subject).to eq(Position.new(x: 1, y: 2))
          expect($stdout.string).to include('Tick Tack Toer, please enter your move')
          expect($stdout.string).to include('Tick Tack Toer, please enter your move')
          expect($stdout.string).to include('Empty move is invalid')
          expect($stdout.string).to include('Please try again with correct format')
          expect($stdout.string).to include('Please enter co-ordinates within the board')
        end
      end
    end

    describe "#print_board" do
      let(:board) { Board.new }
      it 'Prints the board' do
        CommandLineInterface.print_board(board)
        expect($stdout.string).to include(board.to_s)
      end
    end

    describe "#announce_draw" do
      let(:board) { Board.new }
      it "prints game drawn message" do
        CommandLineInterface.announce_draw(board)
        expect($stdout.string).to include('Game was a draw')
        expect($stdout.string).to include(board.to_s)
      end
    end

    describe "#announce_victory" do
      let(:board) { Board.new }
      it "prints game drawn message" do
        CommandLineInterface.announce_victory(board, 'My player')
        expect($stdout.string).to include('My player won the game')
        expect($stdout.string).to include(board.to_s)
      end
    end
  end
end