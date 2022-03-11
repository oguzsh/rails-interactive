# frozen_string_literal: true
module Interactive
  class CLI
    def process_argv(option)
      case option
      when "new"
        puts "Project creating...."
      else
        puts "Invalid parameter"
      end
    end
  end
end
