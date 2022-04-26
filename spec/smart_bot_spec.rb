module TicTacToe
  RSpec.describe SmartBot do
    let(:x_smart_bot) { SmartBot.new(1) } # rank 1 means X
    let(:o_smart_bot) { SmartBot.new(2) } # rank 2 means O

    context 'When there is a winning move' do
      let(:board) do
        Board.new([
          ['O', 'O', 'X'],
          ['X', 'O', 'O'],
          ['X', nil, nil]
        ])
      end

      subject { o_smart_bot.get_move(board) }

      it 'Playes the winning move' do
        expect(subject).to eq(Position.new(x: 1, y: 2))
      end
    end

    context 'If opponnent would win by doing a move' do
      let(:board) do
        Board.new([
          ['O', 'O', 'X'],
          ['X', 'O', 'O'],
          ['X', nil, nil]
        ])
      end

      subject { x_smart_bot.get_move(board) }

      it 'Blocks the move' do
        expect(subject).to eq(Position.new(x: 1, y: 2))
      end
    end

    context 'If winning and opponent winning moves are possible' do
      let(:board) do
        Board.new([
          ['O', 'X', nil],
          ['O', 'X', nil],
          [nil, nil, nil]
        ])
      end

      it 'then it makes winning move' do
        expect(x_smart_bot.get_move(board)).to eq(Position.new(x: 1, y: 2))
        expect(o_smart_bot.get_move(board)).to eq(Position.new(x: 0, y: 2))
      end
    end

    context 'If there are no winning and losing moves' do
      context 'Its a first move' do
        let(:board) do
          Board.new([
            [nil, nil, nil],
            [nil, nil, nil],
            [nil, nil, nil]
          ])
        end

        it 'Occupies a corner' do
          expect(board.corner_positions).to include(x_smart_bot.get_move(board))
        end
      end

      let(:board) do
        Board.new([
          ['O', 'X', nil],
          [nil, nil, nil],
          [nil, nil, nil]
        ])
      end

      it 'Makes a random move' do
        expect(board.available_positions).to include(x_smart_bot.get_move(board))
      end
    end
  end
end