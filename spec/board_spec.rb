module TicTacToe
  RSpec.describe Board do
    describe "Initialization" do
      subject { Board.new() }

      it "Returns empty board" do
        expect(subject).to be_an_instance_of(Board)
      end
    end

    describe "#place" do
      let(:board) { Board.new() }
      let(:position) { Position.new(x: 1, y: 1) }
      let(:symbol) { TicTacToe::CIRCLE }

      subject { board.place(symbol, position) }
      context "When nothing exists on the position" do
        it "places the passed symbol on the passed position" do
          expect { subject }.not_to raise_error
          expect(board.symbol_at(position)).to eq(symbol)
        end
      end

      context "When a symbol already exists on the position" do
        before do
          board.place(symbol, position)
        end

        it "raises error" do
          expect { subject }.to raise_error(Board::InvalidPositionError)
        end
      end
    end

    describe "#result" do
      let(:board) { Board.new() }
      context "Board position does not conclude the game" do
        subject { board.result }
        it "returns nil" do
          expect(subject).to be_nil
        end
      end

      context "Board position corresponds to a player winning horizontally" do
        let(:winning_symbol) { TicTacToe::CIRCLE }
        before do
          # We are creating following scenario
          # | - | - | - |
          # | - | - | - |
          # | O | O | O |
          board.place(winning_symbol, Position.new(x: 0, y: 2))
          board.place(winning_symbol, Position.new(x: 1, y: 2))
          board.place(winning_symbol, Position.new(x: 2, y: 2))
        end

        subject { board.result }
        it "returns victory for O" do
          expect(subject).to eq({ verdict: "win", victor: winning_symbol })
        end
      end

      context "Board position corresponds to a player winning virtically" do
        let(:winning_symbol) { TicTacToe::CROSS }

        before do
          # We are creating following scenario
          # | X | - | - |
          # | X | - | - |
          # | X | - | - |
          board.place(winning_symbol, Position.new(x: 0, y: 0))
          board.place(winning_symbol, Position.new(x: 0, y: 1))
          board.place(winning_symbol, Position.new(x: 0, y: 2))
        end

        subject { board.result }
        it "returns victory for X" do
          expect(subject).to eq({ verdict: "win", victor: winning_symbol })
        end
      end

      context "Board position corresponds to a player winning diagonally on diagonal from 0,0" do
        let(:winning_symbol) { TicTacToe::CROSS }
        before do
          # We are creating following scenario
          # | X | - | - |
          # | - | X | - |
          # | - | - | X |
          board.place(winning_symbol, Position.new(x: 0, y: 0))
          board.place(winning_symbol, Position.new(x: 1, y: 1))
          board.place(winning_symbol, Position.new(x: 2, y: 2))
        end

        subject { board.result }
        it "returns victory for X" do
          expect(subject).to eq({ verdict: "win", victor: winning_symbol })
        end
      end

      context "Board position corresponds to a player winning diagonally on diagonal from 0,2" do
        let(:winning_symbol) { TicTacToe::CIRCLE }
        before do
          # We are creating following scenario
          # | - | - | O |
          # | - | O | - |
          # | O | - | - |
          board.place(winning_symbol, Position.new(x: 0, y: 0))
          board.place(winning_symbol, Position.new(x: 1, y: 1))
          board.place(winning_symbol, Position.new(x: 2, y: 2))
        end

        subject { board.result }
        it "returns victory for O" do
          expect(subject).to eq({ verdict: "win", victor: winning_symbol })
        end
      end

      context "Board position corresponds to draw" do
        before do
          # We are creating following scenario
          # | X | O | X |
          # | X | O | X |
          # | O | X | O |
          board.place(TicTacToe::CROSS, Position.new(x: 0, y: 0))
          board.place(TicTacToe::CIRCLE, Position.new(x: 1, y: 0))
          board.place(TicTacToe::CROSS, Position.new(x: 2, y: 0))
          board.place(TicTacToe::CROSS, Position.new(x: 0, y: 1))
          board.place(TicTacToe::CIRCLE, Position.new(x: 1, y: 1))
          board.place(TicTacToe::CROSS, Position.new(x: 2, y: 1))
          board.place(TicTacToe::CIRCLE, Position.new(x: 0, y: 2))
          board.place(TicTacToe::CROSS, Position.new(x: 1, y: 2))
          board.place(TicTacToe::CIRCLE, Position.new(x: 2, y: 2))
        end

        subject { board.result }
        it "returns draw" do
          expect(subject).to eq({ verdict: "draw" })
        end
      end
    end

    describe "#available_positions" do
      let(:board) do
        Board.new([
          [nil, "O", "X"],
          ["X", nil, "O"],
          ["X", "O", nil],
        ])
      end

      it "Returns a random valid move on the board" do
        # there are only 3 valid positions on the board
        # (0,0), (1,1), (2,2)

        correct_available_positions = [
          Position.new(x: 0, y: 0),
          Position.new(x: 1, y: 1),
          Position.new(x: 2, y: 2),
        ]

        returned_positions = board.available_positions

        expect(returned_positions.size).to eq(3)
        returned_positions.each do |returned_position|
          expect(correct_available_positions).to include(returned_position)
        end
      end
    end

    describe "#class_methods" do
      describe "#possible_paths_with_verdicts" do
        let(:board) do
          Board.new([
            ["O", "X", "O"],
            ["X", "X", "O"],
            ["X", nil, nil],
          ])
        end

        let(:symbol_to_place) { TicTacToe::CIRCLE }

        subject { board.possible_paths_with_verdicts(symbol_to_place) }

        it "returns all possible move sequences with verdicts" do
          # There are two possible future paths.
          # 1. If we place circle at 1,2 then cross needs to be placed
          # at 2,2 and it will be draw.
          # 2. If we place circle at 2,2 then it will be victory for white
          expect(subject.size).to eq(2)
          circle_winning_path = subject.detect { |path| path.result == { verdict: "win", victor: symbol_to_place } }
          expect(circle_winning_path).to be_truthy
          p_22 = Position.new(x: 2, y: 2)
          p_12 = Position.new(x: 1, y: 2)
          expect(circle_winning_path.moves).to eq([GameMove.new(p_22, TicTacToe::CIRCLE)])

          draw_path = subject.detect { |path| path.result == { verdict: "draw" } }
          expect(draw_path).to be_truthy
          expect(draw_path.moves).to eq([
            GameMove.new(p_12, TicTacToe::CIRCLE),
            GameMove.new(p_22, TicTacToe::CROSS),
          ])
        end
      end
    end
  end
end
