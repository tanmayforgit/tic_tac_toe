module TicTacToe
  module StringHelper
    class << self
      def is_a_single_word?(string)
        string.split(' ').length == 1
      end

      def is_a_integer?(string)
        string.to_i.to_s == string
      end
    end
  end
end