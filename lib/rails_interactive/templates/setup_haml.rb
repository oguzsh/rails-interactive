# frozen_string_literal: true

def bundle_install
  Bundler.with_unbundled_env { run "bundle install" }
end

run "bundle add haml"
bundle_install

if yes?("Would you like to convert your existing *.erb files to *.haml files? [y/n]")
  run "bundle add erb2haml --group 'development'"
  bundle_install
  if yes?("Would you like to keep the original *.erb files? [y/n]")
    rake "haml:convert_erbs"
  else
    rake "haml:replace_erbs"
  end
end
