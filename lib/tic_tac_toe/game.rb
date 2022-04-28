module TicTacToe
  require 'aasm'
  ##
  # This class serves as a state machine
  #
  # This is how the machine success flow looks like:
  # (IDLE)--start-->(ACCEPTING_P1_NAME)
  # (ACCEPTING_P1_NAME)--accept_p1_name(valid_name)-->(ACCEPTING_P2_NAME)
  # (ACCEPTING_P2_NAME)--accept_p2_name(valid_name)-->(WAITING_P1_TO_MOVE)
  # (WAITING_P1_TO_MOVE)--valid_move-->(WAITING_P2_TO_MOVE)
  # (WAITING_P2_TO_MOVE--valid_move-->(WAITING_P1_TO_MOVE)
  # .
  # .
  # .
  # (ACCEPTING_P1/P2_MOVE)--game_ending_move-->(FINISHED)

  # Various other flows are:
  # (ACCEPTING_P1_NAME)--accept_p1_name(invalid_name)-->(ACCEPTING_P1_NAME)
  # (ACCEPTING_P2_NAME)--accept_p2_name(invalid_name)-->(ACCEPTING_P2_NAME)
  # (WAITING_P1_TO_MOVE)--invalid_move-->(WAITING_P1_TO_MOVE)
  # (WAITING_P2_TO_MOVE)--invalid_move-->(WAITING_P2_TO_MOVE)

  # For any state that the game is in, this class answers what is the next action
  # that needs to happen on the game
  # e.g. if game is in WAITING_P1_TO_MOVE state then game.action_to_perform will be get_p1_move
  # Game starts with game.action_to_perform as give_introduction
  #
  class Game
    include AASM
    attr_reader :action_to_perform, :board, :id

    def initialize()
      @board = Board.new()
      @p1_name = nil
      @p2_name = nil
      set_action(GameAction.new(:give_introduction))
      @id = rand(1_00_000..1_000_000)
    end

    aasm do
      # Describing the states
      state :idle, initial: true
      state :accepting_p1_name, after_enter: Proc.new { set_action(GameAction.new(:get_p1_name)) }
      state :accepting_p2_name, after_enter: Proc.new { set_action(GameAction.new(:get_p2_name)) }
      state :waiting_p1_to_move, after_enter: Proc.new { set_action(GameAction.new(:get_p1_move)) }
      state :waiting_p2_to_move, after_enter: Proc.new { set_action(GameAction.new(:get_p2_move)) }
      state :finished

      # Describing the events and transitions
      event :start do
        transitions from: :idle, to: :accepting_p1_name
      end

      event :accept_p1_name do
        transitions from: :accepting_p1_name, to: :accepting_p2_name, if: :capture_and_validate_p1_name
      end

      event :accept_p2_name do
        transitions from: :accepting_p2_name, to: :waiting_p1_to_move, if: :capture_and_validate_p2_name
      end

      event :accept_p1_move do
        transitions from: :waiting_p1_to_move, to: :waiting_p2_to_move, if: Proc.new { |position| capture_and_validate_move(TicTacToe::CROSS, position) }

        after do
          set_concluding_action_if_game_ends
        end
      end

      event :accept_p2_move do
        transitions from: :waiting_p2_to_move, to: :waiting_p1_to_move, if: Proc.new { |position| capture_and_validate_move(TicTacToe::CIRCLE, position) }

        after do
          set_concluding_action_if_game_ends
        end
      end

      # By default if any state transition fails due to guard
      # clauses (guard clauses are if condition mentioned in
      # the transitions), then aasm will raise AASM::InvalidTransition error.
      # Cases in which guard conditions will fail are handled by
      # adding relevant errors to the current game action to perform.
      # We don't want game to raise error when transition fails due to our
      # guard clauses since that will unnecessarily complicate code
      # using this class. Failing the transition with instrumenting
      # what happened is sufficient for our use case
      error_on_all_events do |error|
        # AASM will add errors due to callback failures to failures array. If there
        # are any failures then that would mean error was due to our guard clause
        if error.is_a?(AASM::InvalidTransition) && error.failures.any?
          TicTacToe::LOGGER.info("rescuing error #{error.inspect}")
        else
          raise error
        end
      end

      # We don't want errors from one event to be shown for next event
      before_all_events :clear_current_action_errors
    end

    def state
      self.aasm.current_state
    end

    private

    def set_concluding_action_if_game_ends
      result = @board.result
      if result
        set_game_conclusion_action(result)
        aasm.current_state= :finished
      end
    end

    def set_game_conclusion_action(result)
      verdict = result.fetch(:verdict)
      case verdict
      when 'win'
        victorious_symbol = result.fetch(:victor)
        set_action(GameAction.new(:announce_victory, {symbol: victorious_symbol}))
      when 'draw'
        set_action(GameAction.new(:announce_draw))
      end
    end

    def capture_and_validate_move(symbol, position)
      @board.place(symbol, position)
      true
    rescue Board::InvalidPositionError => e
      @action_to_perform.add_error('Illegal move')
      false
    end

    def set_action(action)
      @action_to_perform = action
    end

    def capture_and_validate_p1_name(name)
      if !name_present?(name)
        @action_to_perform.add_error('p1 name should be present')
        return false
      end

      @p1_name = name
      true
    end

    def capture_and_validate_p2_name(name)
      if !name_present?(name)
        @action_to_perform.add_error('p2 name should be present')
        return false
      end

      if name == @p1_name
        @action_to_perform.add_error('p2 name should not match p1 name')
        return false
      end

      @p2_name = name
      true
    end

    def name_present?(name)
      name.to_s.length > 0
    end

    def clear_current_action_errors
      @action_to_perform.clear_errors if @action_to_perform
    end

    class GameAction
      attr_reader :name, :details, :errors
      def initialize(action_name, details = {})
        @name = action_name
        @details = details
        @errors = []
      end

      def clear_errors
        @errors = []
      end

      def add_error(error)
        @errors << error
      end
    end
  end
end