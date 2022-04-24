module TicTacToe
  RSpec.describe Game do
    describe 'initialization' do
      subject { Game.new() }
      it "Starts in idle state and next action to perform is to display board and instruction" do
        expect(subject.state).to eq(:idle)

        action_to_perform = game.action_to_perform
        expect(action_to_perform.name).to eq(:give_introduction)
      end
    end

    let(:game) { Game.new() }

    describe '#start' do
      subject { game.start }
      it "starts by setting action_to_perform to get_p1_name" do
        expect{ subject }.to change{ game.state }.from(:idle).to(:accepting_p1_name)
        action_to_perform = game.action_to_perform
        expect(action_to_perform.name).to eq(:get_p1_name)
      end
    end

    describe '#accept_p1_name' do
      before do
        game.start
      end

      context "When valid p1 name is provided" do
        subject { game.accept_p1_name('p1 name') }

        it "Accepts p1 name, transitions to accepting_p2_name state and action_to_perform is get_p2_name" do
          expect{ subject }.to change{ game.state }.from(:accepting_p1_name).to(:accepting_p2_name)

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

    describe "player moves" do
      # Player move events are :accept_p1_move and :accept_p2_move
      # After accepting the player names, game starts by waiting for p1 to move.
      # When p1 moves, game waits for p2 to move so on and so forth till
      # game concludes

      before do
        game.start
        game.accept_p1_name("p1")
        game.accept_p2_name("p2")
      end

      let(:position_0_1) { Position.new(x: 0, y: 1) }
      let(:position_0_2) { Position.new(x: 0, y: 2) }

      context 'When move is valid' do
        context 'When move is non game ending' do
          it "Accepts the move and transitions to 'waiting for the other player to move state'" do
            expect { game.accept_p1_move(position_0_1) }.to change { game.state }.from(:waiting_p1_to_move).to(:waiting_p2_to_move)
            action_to_perform = game.action_to_perform
            expect(action_to_perform.name).to eq(:get_p2_move)

            expect { game.accept_p2_move(position_0_2) }.to change { game.state }.from(:waiting_p2_to_move).to(:waiting_p1_to_move)
            action_to_perform = game.action_to_perform
            expect(action_to_perform.name).to eq(:get_p1_move)
          end
        end

        context 'When move is game ending' do
          context 'When move results in a player winning' do
            before do
              # We are creating following scenario where
              # move to 2,2 by X player will win the game for him/her
              # | X | - | O |
              # | - | X | O |
              # | - | - | - |

              game.accept_p1_move(Position.new(x: 0, y: 0))
              game.accept_p2_move(Position.new(x: 2, y: 0))
              game.accept_p1_move(Position.new(x: 1, y: 1))
              game.accept_p2_move(Position.new(x: 2, y: 1))
            end

            subject { game.accept_p1_move(Position.new(x: 2, y: 2)) }

            it "Accepts the move and transitions to finished state and action_to_perform is to announce victory for X player" do
              expect { subject }.to change { game.state }.from(:waiting_p1_to_move).to(:finished)
              action_to_perform = game.action_to_perform
              expect(action_to_perform.name).to eq(:announce_victory)
              expect(action_to_perform.details.fetch(:symbol)).to eq(TicTacToe::CROSS)
            end
          end

          context 'When move results in a draw' do
            before do
              # We will create following scenario
              # | X | O | - |
              # | X | O | X |
              # | O | X | O |
              # So p1 placing cross at (2,0) will result in a draw

              game.accept_p1_move(Position.new(x: 0, y: 0))
              game.accept_p2_move(Position.new(x: 1, y: 0))
              game.accept_p1_move(Position.new(x: 2, y: 1))
              game.accept_p2_move(Position.new(x: 1, y: 1))
              game.accept_p1_move(Position.new(x: 0, y: 1))
              game.accept_p2_move(Position.new(x: 0, y: 2))
              game.accept_p1_move(Position.new(x: 1, y: 2))
              game.accept_p2_move(Position.new(x: 2, y: 2))
            end

            subject { game.accept_p1_move(Position.new(x: 2, y: 0)) }

            it "Accepts the move and transitions to finished state and action to perform is to announce a draw" do
              expect { subject }.to change { game.state }.from(:waiting_p1_to_move).to(:finished)
              action_to_perform = game.action_to_perform
              expect(action_to_perform.name).to eq(:announce_draw)
            end
          end
        end
      end

      context "When move is invalid" do
        before do
          # we will already make a move to position_0_1 so
          # subject trying to make the same move again will be
          # invalid
          game.accept_p1_move(position_0_1)
        end

        subject { game.accept_p2_move(position_0_1) }
        it "Does not accept the move and action to perform has appropriate error" do
          expect { subject }.not_to change { game.state }
          action_to_perform = game.action_to_perform
          expect(action_to_perform.errors).to include('Illegal move')
        end
      end
    end
  end
end