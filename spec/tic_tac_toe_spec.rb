module TicTacToe
  RSpec.describe TicTacToe do
    # This test file is to test end to end flow once.
    # Finer cases are handled in respective unit test cases

    before(:each) do
      # Setting the stdout to stringIO so that we can match the
      # expected output
      $stdout = StringIO.new
    end

    after(:each) do
      $stdout = STDOUT
    end

    it 'Plays a game of tic tac toe which can results in a players victory' do
      # Test case simulates accepting player 1 name as name1 and
      # player 2 name as name2

      # It then simulates following board position and then we assert that
      # player 1 won the game
      # | X | - | O |
      # | - | X | O |
      # | - | - | X |

      allow(STDIN).to receive(:gets).and_return(
        "name1",
        "name2",
        "0,0",
        "2,0",
        "1,1",
        "2,1",
        "2,2"
      )
      TicTacToe.play()
      expect($stdout.string).to include("name1 won the game")
    end

    it 'Plays a game of tic tac toe which can results in draw' do
      # Test case simulates accepting player 1 name as name1 and
      # player 2 name as name2

      # It then simulates following board position and then we assert that
      # it was a draw
      # | X | O | X |
      # | X | O | X |
      # | O | X | O |

      allow(STDIN).to receive(:gets).and_return(
        "name1",
        "name2",
        "0,0",
        "1,0",
        "2,1",
        "1,1",
        "0,1",
        "0,2",
        "1,2",
        "2,2",
        "2,0"
      )
      TicTacToe.play()
      expect($stdout.string).to include("Game was a draw")
    end
  end
end