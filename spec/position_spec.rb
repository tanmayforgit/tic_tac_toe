module TicTacToe
  RSpec.describe Position do
    describe 'Initialization' do
      subject { Position.new(x: 2, y: 0) }
      it "returns position object" do
        expect(subject).to be_an_instance_of(Position)
        expect(subject.x). to eq(2)
        expect(subject.y). to eq(0)
      end
    end
  end
end