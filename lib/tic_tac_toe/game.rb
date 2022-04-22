module TicTacToe
  require 'aasm'

  class Game
    include AASM
    attr_reader :action_to_perform, :p1_name

    def initialize()
      @p1_name = nil
      @p2_name = nil
      @action_to_perform = nil
    end

    aasm do
      state :idle, initial: true
      state :accepting_p1_name, after_enter: Proc.new { set_action(GameAction.new(:get_p1_name)) }
      state :accepting_p2_name, after_enter: Proc.new { set_action(GameAction.new(:get_p2_name)) }
      state :waiting_p1_to_move, after_enter: Proc.new { set_action(GameAction.new(:get_p1_move)) }

      event :start do
        transitions from: :idle, to: :accepting_p1_name
      end

      event :accept_p1_name do
        transitions from: :accepting_p1_name, to: :accepting_p2_name, if: :capture_and_validate_p1_name
      end

      event :accept_p2_name do
        transitions from: :accepting_p2_name, to: :waiting_p1_to_move, if: :capture_and_validate_p2_name
      end

      # By default if any state transition fails due to guard clauses (i.e. if condition mentioned in the transitions)
      # Then aasm will raise AASM::InvalidTransition error.
      # We are handling conditions in which transitions will fail gracefully by adding relevant errors to the game action
      # We don't want game to raise error when a game event fails.
      # Failing the transition with instrumenting what happened is sufficient for
      # our use case
      error_on_all_events do |error|
        if error.is_a?(AASM::InvalidTransition)
          TicTacToe::LOGGER.error(error.message)
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

    def aasm_event_failed(event_name, old_state)
      puts "called aasm_event_failed"
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