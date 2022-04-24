module TicTacToe
  RSpec.describe HumanPlayer do
    let(:cli) { double(get_name: 'Mr right', get_move: Position.new(x: 2, y: 0)) }
    let(:human_player) { HumanPlayer.new(1, cli) }

    describe '#keep_or_change_name' do
      subject { human_player.keep_or_change_name }

      it 'keeps new or changes the name with the help of cli' do
        expect(subject).to eq('Mr right')
        expect(human_player.name).to eq('Mr right')
      end
    end

    describe '#get_move' do
      let(:board) { Board.new }
      subject { human_player.get_move(board) }
      it 'Gets the move with the help of cli' do
        expect(subject).to eq(cli.get_move)
      end
    end
  end
end