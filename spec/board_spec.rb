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
  end
end