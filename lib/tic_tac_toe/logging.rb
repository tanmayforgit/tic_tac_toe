module TicTacToe
  module Logging
    class << self
      def create_logger()
        logger = Logger.new(STDOUT)
        logger.level = Logger::INFO

        logger
      end
    end
  end
end