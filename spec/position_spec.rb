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
        it "Raises PositionOutOfBoard" do
          expect { Position.new(x: 3, y: 0)}.to raise_error(Position::PositionOutOfBoard)
          expect { Position.new(x: -1, y: 0)}.to raise_error(Position::PositionOutOfBoard)
        end
      end
    end

    describe 'from_string' do
      # String should be comma separated co ordinates
      context 'string is not in proper format' do
        it 'raises incorrect format error' do
          expect { Position.from_string('1 2') }.to raise_error(Position::IncorrectFormat)
          expect { Position.from_string(23) }.to raise_error(Position::IncorrectFormat)
          expect { Position.from_string('1-2') }.to raise_error(Position::IncorrectFormat)
        end
      end
    end
  end
end