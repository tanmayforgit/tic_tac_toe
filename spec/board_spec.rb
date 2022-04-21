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
      let(:symbol_to_place) { TicTacToe::CIRCLE }

      context 'when nothing exists on the position' do
        subject { board.place(symbol_to_place, position) }
        it 'places the passed symbol on the passed position' do
          expect{ subject }.not_to raise_error
          expect(board.symbol_at(position)).to eq(symbol_to_place)
        end
      end
    end
  end
end