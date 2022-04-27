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

      context 'String is in single number format' do
        it 'Converts and returns position in x,y format' do
          expect(Position.from_string('1')).to eq(Position.new(x: 0, y: 0))
          expect(Position.from_string('3')).to eq(Position.new(x: 2, y: 0))
          expect(Position.from_string('4')).to eq(Position.new(x: 0, y: 1))
          expect(Position.from_string('5')).to eq(Position.new(x: 1, y: 1))
          expect(Position.from_string('9')).to eq(Position.new(x: 2, y: 2))

          expect { Position.from_string('0') }.to raise_error(Position::PositionOutOfBoard)
          expect { Position.from_string('10') }.to raise_error(Position::PositionOutOfBoard)
          expect { Position.from_string('abcd') }.to raise_error(Position::IncorrectFormat)
        end
      end
    end
  end
end