module Interactive
  # Utils class for the interactive CLI module
  class Utils
    def self.greet
      render_ascii
      puts "Welcome to Rails Interactive CLI - #{Interactive::VERSION}"
    end

    def self.help
      puts "bin/interactive new - Create a new Rails Project"
      puts "bin/interactive help - List all commands"
      exit
    end

    def self.render_ascii
      # rubocop:disable Naming/HeredocDelimiterNaming
      puts <<-'EOF'
  ___       _                      _   _           ____       _ _
 |_ _|_ __ | |_ ___ _ __ __ _  ___| |_(_)_   _____|  _ \ __ _(_) |___
  | || '_ \| __/ _ \ '__/ _` |/ __| __| \ \ / / _ \ |_) / _` | | / __|
  | || | | | ||  __/ | | (_| | (__| |_| |\ V /  __/  _ < (_| | | \__ \
 |___|_| |_|\__\___|_|  \__,_|\___|\__|_| \_/ \___|_| \_\__,_|_|_|___/

      EOF
      # rubocop:enable Naming/HeredocDelimiterNaming
    end
  end
end
