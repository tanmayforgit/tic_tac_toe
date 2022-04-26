module TicTacToe
  RSpec.describe Path do
    describe '#traverse_one_step' do
      let(:board) do
        Board.new([
          ['O', 'O', 'X'],
          ['X', nil, 'O'],
          ['X', 'O', nil]
        ])
      end
      let(:symbol_to_place) { TicTacToe::CIRCLE }

      subject { Path.new([], board, symbol_to_place).traverse_one_step }
      it 'Gives all the paths possible after one step' do
        expect(subject.size).to eq(2)
        possible_position_1 = Position.new(x: 1, y: 1)
        possible_position_2 = Position.new(x: 2, y: 2)
        next_symbol_to_place = TicTacToe.the_other_symbol(symbol_to_place)

        possible_path_1 = Path.new(
          [GameMove.new(possible_position_1, symbol_to_place)],
          Board.new([
            ['O', 'O', 'X'],
            ['X', 'O', 'O'],
            ['X', 'O', nil]
          ]), next_symbol_to_place
        )

        possible_path_2 = Path.new(
          [GameMove.new(possible_position_2, symbol_to_place)],
          Board.new([
            ['O', 'O', 'X'],
            ['X', nil, 'O'],
            ['X', 'O', 'O']
          ]), next_symbol_to_place
        )
        expect(subject).to include(possible_path_1)
        expect(subject).to include(possible_path_2)
      end

      context 'board represents a concluded game' do
        let(:board) do
          Board.new([
            ['O','O','O'],
            ['X', 'X', nil],
            [nil, nil, nil]
          ])
        end

        let(:symbol_to_place) { TicTacToe::CROSS }
        subject { Path.new([], board, symbol_to_place).traverse_one_step }
        it 'returns empty array' do
          expect(subject).to eq([])
        end
      end
    end

    describe '#winning_for?' do
      context 'board is winning for a symbol' do
        let(:board) do
          Board.new([
            ['O', 'O', 'X'],
            ['X', 'X', 'O'],
            ['X', 'O', nil]
          ])
        end
        let(:path) { Path.new([], board, TicTacToe::CIRCLE) }
        it 'returns true if verdict is winning for passed symbol' do
          expect(path.winning_for?(TicTacToe::CROSS)).to be_truthy
          expect(path.winning_for?(TicTacToe::CIRCLE)).to be_falsey
        end
      end

      context 'board is a draw' do
        let(:board) do
          Board.new([
            ['O', 'O', 'X'],
            ['X', 'X', 'O'],
            ['O', 'X', 'O']
          ])
        end

        let(:path) { Path.new([], board, TicTacToe::CIRCLE) }
        it 'returns false' do
          expect(path.winning_for?(TicTacToe::CROSS)).to be_falsey
          expect(path.winning_for?(TicTacToe::CIRCLE)).to be_falsey
        end
      end

      context 'board is unconcluded' do
        let(:board) do
          Board.new([
            ['O', 'O', 'X'],
            ['X', 'X', nil],
            ['O', 'X', nil]
          ])
        end

        let(:path) { Path.new([], board, TicTacToe::CIRCLE) }
        it 'returns false' do
          expect(path.winning_for?(TicTacToe::CROSS)).to be_falsey
          expect(path.winning_for?(TicTacToe::CIRCLE)).to be_falsey
        end
      end
    end
  end
end