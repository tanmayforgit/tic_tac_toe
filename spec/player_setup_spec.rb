module TicTacToe
  RSpec.describe PlayerSetup do
    describe 'do' do
      before(:each) do
        # Setting the stdout to stringIO so that we can match the
        # expected output
        $stdout = StringIO.new
      end

      after(:each) do
        $stdout = STDOUT
      end

      let(:player_rank) { 1 }

      subject { PlayerSetup.call(player_rank) }

      context 'End user opts for human player' do
        it 'Returns HumanPlayer instance' do
          allow(STDIN).to receive(:gets).and_return('1')
          expected_op_msg = "Please enter player #{player_rank} type:\n1. Human  2. Random Bot 3. Smart Bot"
          expect(subject).to be_an_instance_of(HumanPlayer)
          expect($stdout.string).to include(expected_op_msg)
        end
      end

      context 'End user opts for random bot' do
        it 'Returns RandomBot instance' do
          allow(STDIN).to receive(:gets).and_return('2')
          expected_op_msg = "Please enter player #{player_rank} type:\n1. Human  2. Random Bot 3. Smart Bot"
          expect(subject).to be_an_instance_of(RandomBot)
          expect($stdout.string).to include(expected_op_msg)
        end
      end

      context 'End user enters unknown input' do
        it 'Asks again and again till end user enters valid response' do
          allow(STDIN).to receive(:gets).and_return('5', '1')
          expected_op_msg = "Please enter player #{player_rank} type:\n1. Human  2. Random Bot 3. Smart Bot"
          expect(subject).to be_an_instance_of(HumanPlayer)
          expect($stdout.string).to include(expected_op_msg)
          expect($stdout.string).to include('Unknown response')
        end
      end
    end
  end
end