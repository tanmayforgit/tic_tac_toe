module TicTacToe
  RSpec.describe Board do
    describe 'Initialization' do
      subject { Board.new() }

      it 'Returns empty board' do
        expect(subject).to be_an_instance_of(Board)
      end
    end

    describe '#place' do
      let(:board) { Board.new() }
      let(:position) { Position.new(x: 1, y: 1) }
      let(:symbol) { TicTacToe::CIRCLE }

      subject { board.place(symbol, position) }
      context 'When nothing exists on the position' do
        it 'places the passed symbol on the passed position' do
          expect{ subject }.not_to raise_error
          expect(board.symbol_at(position)).to eq(symbol)
        end
      end

      context 'When a symbol already exists on the position' do
        before do
          board.place(symbol, position)
        end

        it 'raises error' do
          expect{ subject }.to raise_error(Board::InvalidPositionError)
        end
      end
    end

    describe '#result' do
      let(:board) { Board.new() }
      context 'Board position does not conclude the game' do
        subject { board.result }
        it "returns nil" do
          expect(subject).to be_nil
        end
      end

      context 'Board position corresponds to a player winning horizontally' do
        let(:winning_symbol) { TicTacToe::CIRCLE }
        before do
          # We are creating following scenario
          # | - | - | - |
          # | - | - | - |
          # | O | O | O |
          board.place(winning_symbol, Position.new(x: 0, y: 2))
          board.place(winning_symbol, Position.new(x: 1, y: 2))
          board.place(winning_symbol, Position.new(x: 2, y: 2))
        end

        subject { board.result }
        it 'returns victory for O' do
          expect(subject).to eq({verdict: 'win', victor: winning_symbol})
        end
      end

      context 'Board position corresponds to a player winning virtically' do
        let(:winning_symbol) { TicTacToe::CROSS }

        before do
          # We are creating following scenario
          # | X | - | - |
          # | X | - | - |
          # | X | - | - |
          board.place(winning_symbol, Position.new(x: 0, y: 0))
          board.place(winning_symbol, Position.new(x: 0, y: 1))
          board.place(winning_symbol, Position.new(x: 0, y: 2))
        end

        subject { board.result }
        it 'returns victory for X' do
          expect(subject).to eq({verdict: 'win', victor: winning_symbol})
        end
      end

      context 'Board position corresponds to a player winning diagonally on diagonal from 0,0' do
        let(:winning_symbol) { TicTacToe::CROSS }
        before do
          # We are creating following scenario
          # | X | - | - |
          # | - | X | - |
          # | - | - | X |
          board.place(winning_symbol, Position.new(x: 0, y: 0))
          board.place(winning_symbol, Position.new(x: 1, y: 1))
          board.place(winning_symbol, Position.new(x: 2, y: 2))
        end

        subject { board.result }
        it 'returns victory for X' do
          expect(subject).to eq({verdict: 'win', victor: winning_symbol})
        end
      end

      context 'Board position corresponds to a player winning diagonally on diagonal from 0,2' do
        let(:winning_symbol) { TicTacToe::CIRCLE }
        before do
          # We are creating following scenario
          # | - | - | O |
          # | - | O | - |
          # | O | - | - |
          board.place(winning_symbol, Position.new(x: 0, y: 0))
          board.place(winning_symbol, Position.new(x: 1, y: 1))
          board.place(winning_symbol, Position.new(x: 2, y: 2))
        end

        subject { board.result }
        it 'returns victory for O' do
          expect(subject).to eq({verdict: 'win', victor: winning_symbol})
        end
      end

      context 'Board position corresponds to draw' do
        before do
          # We are creating following scenario
          # | X | O | X |
          # | X | O | X |
          # | O | X | O |
          board.place(TicTacToe::CROSS, Position.new(x: 0, y: 0))
          board.place(TicTacToe::CIRCLE, Position.new(x: 1, y: 0))
          board.place(TicTacToe::CROSS, Position.new(x: 2, y: 0))
          board.place(TicTacToe::CROSS, Position.new(x: 0, y: 1))
          board.place(TicTacToe::CIRCLE, Position.new(x: 1, y: 1))
          board.place(TicTacToe::CROSS, Position.new(x: 2, y: 1))
          board.place(TicTacToe::CIRCLE, Position.new(x: 0, y: 2))
          board.place(TicTacToe::CROSS, Position.new(x: 1, y: 2))
          board.place(TicTacToe::CIRCLE, Position.new(x: 2, y: 2))
        end

        subject { board.result }
        it 'returns draw' do
          expect(subject).to eq({verdict: 'draw'})
        end
      end
    end
  end
end