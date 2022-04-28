module TicTacToe
  RSpec.describe GameCreator do
    subject { GameCreator.create() }
    it 'Creates a game and creates a file which will be used to join the game' do
      expect(subject).to be_an_instance_of(Game)
      expect(subject.id).to be_a_kind_of(Integer)
      expect(File.exists?("../tmp/#{subject.id}.txt"))
    end
  end
end