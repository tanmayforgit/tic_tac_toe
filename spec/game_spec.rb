module TicTacToe
  RSpec.describe Game do
    describe '#start' do
      let(:game) { Game.new() }

      subject { game.start }
      it "starts by setting action_to_perform to get_p1_name" do
        expect{ subject }.to change{ game.state }.from(:idle).to(:accepting_p1_name)
        action_to_perform = game.action_to_perform
        expect(action_to_perform.name).to eq(:get_p1_name)
      end

      describe '#accept_p1_name' do
        before do
          game.start
        end

        context "When valid p1 name is provided" do
          subject { game.accept_p1_name('p1 name') }

          it "Accepts p1 name, transitions to accepting_p2_name state and action_to_perform is get_p2_name" do
            expect{ subject }.to change{ game.state }.from(:accepting_p1_name).to(:accepting_p2_name)

            expect(game.p1_name).to eq('p1 name')
            action_to_perform = game.action_to_perform
            expect(action_to_perform.name).to eq(:get_p2_name)
          end
        end

        context "invalid p1 name is provided" do
          subject { game.accept_p1_name("") }

          it "Does not accept the name and remains in accepting_p1_name state" do
            expect{ subject }.not_to change{ game.state }
            expect(game.state).to eq(:accepting_p1_name)
            action_to_perform = game.action_to_perform
            expect(action_to_perform.name).to eq(:get_p1_name)
            expect(action_to_perform.errors).to eq(['p1 name should be present'])
          end
        end
      end

      describe '#accept_p2_name' do
        before do
          game.start
          game.accept_p1_name('first player')
        end

        context "When valid p2 name is provided" do
          subject { game.accept_p2_name("second player") }

          it "transitions to waiting_p1_to_move state and action_to_perform is get_p1_move" do
            expect{ subject }.to change{ game.state }.from(:accepting_p2_name).to(:waiting_p1_to_move)

            action_to_perform = game.action_to_perform
            expect(action_to_perform.name).to eq(:get_p1_move)
          end
        end

        context "When p2 name matches p1 name" do
          subject { game.accept_p2_name("first player") }

          it "Does not accept the name and remains in accepting_p2_name state" do
            expect{ subject }.not_to change{ game.state }


            expect(game.state).to eq(:accepting_p2_name)
            action_to_perform = game.action_to_perform
            expect(action_to_perform.name).to eq(:get_p2_name)
            expect(action_to_perform.errors).to eq(['p2 name should not match p1 name'])
          end
        end
      end
    end
  end
end