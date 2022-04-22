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

    aasm() do
      state :idle, initial: true
      state :accepting_p1_name, after_enter: :ask_p1_name
      state :accepting_p2_name, after_enter: :ask_p2_name
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

      # We don't want errors from one event to be shown for next event
      before_all_events :clear_current_action_errors
    end

    private

    def ask_p1_name
      @action_to_perform = GameAction.new(:ask_p1_name)
    end

    def ask_p2_name
      @action_to_perform = GameAction.new(:ask_p2_name)
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