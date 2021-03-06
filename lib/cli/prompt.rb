# frozen_string_literal: true

require "tty/prompt"

module RailsInteractive
  class CLI
    # Prompt class for commands
    class Prompt
      # Create a new instance
      #
      # @param msg [String] the message to display
      # @param type [String] the type of prompt
      # @param options [Array] the options to display
      # @param required [Boolean] whether the prompt value is required
      #
      # @return [Interactive::Prompt] the new instance
      def initialize(msg, type, options = nil, required: false)
        @msg = msg
        @type = type
        @options = options
        @required = required
        @prompt = TTY::Prompt.new
      end

      # Perform the prompt
      #
      # @return [String] the value of the prompt
      def perform
        case @type
        when "ask"
          @prompt.ask(@msg, required: @required)
        when "select"
          @prompt.select(@msg, @options, required: @required)
        when "multi_select"
          @prompt.multi_select(@msg, @options)
        else
          puts "Invalid parameter"
        end
      end
    end
  end
end
