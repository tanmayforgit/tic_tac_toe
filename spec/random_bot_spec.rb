module TicTacToe
  RSpec.describe RandomBot do
    let(:random_bot) { RandomBot.new }

    describe "#keep_or_change_name" do
      subject { random_bot.keep_or_change_name }
      it "Names itself as random bot '<some number between 101 and 999>' " do
        expect(subject).to match(/Random bot \d\d\d/)
        returned_name = subject
        expect(random_bot.name).to eq(returned_name)
      end
    end

    describe '#get_move' do
      context 'There are feasible moves on the board' do
        let(:board) do
          Board.new([
            [nil, 'O', 'X'],
            ['X', nil, 'O'],
            ['X', 'O', nil]
          ])
        end

        it 'Returns a random valid move on the board' do
          available_positions = board.available_positions

          returned_random_moves = 20.times.map do
            random_bot.get_move(board)
          end

          returned_random_moves.each do |returned_random_move|
            expect(available_positions).to include(returned_random_move)
          end

          # asserting that it is random and does not return same move all the time
          expect(returned_random_moves.uniq.size).not_to eq(1)
        end
      end
    end
  end
end