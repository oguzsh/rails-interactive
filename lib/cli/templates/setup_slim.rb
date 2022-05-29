# frozen_string_literal: true

def bundle_install
  Bundler.with_unbundled_env { run "bundle install" }
end

run "bundle add slim-rails"

bundle_install

if yes?("Would you like to convert your existing *.erb files to *.slim files? [y/n]")
  run "bundle add html2slim --group 'development'"
  bundle_install
  if yes?("Would you like to keep the original *.erb files? [y/n]")
    run "erb2slim app/views"
  else
    run "erb2slim app/views -d"
  end
end
