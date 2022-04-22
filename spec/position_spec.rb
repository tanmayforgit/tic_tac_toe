module TicTacToe
  RSpec.describe Position do
    describe 'Initialization' do
      context "When valid args are passed" do
        subject { Position.new(x: 2, y: 0) }
        it "returns position object" do
          expect(subject).to be_an_instance_of(Position)
          expect(subject.x). to eq(2)
          expect(subject.y). to eq(0)
        end
      end

      context "When args correspond to position out of board or negative co ordinates" do
        it "Raises InvalidPositionError" do
          expect { Position.new(x: 3, y: 0)}.to raise_error(Position::InvalidPositionError)
          expect { Position.new(x: -1, y: 0)}.to raise_error(Position::InvalidPositionError)
        end
      end
    end
  end
end