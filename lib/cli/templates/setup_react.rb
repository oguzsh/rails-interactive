# frozen_string_literal: true

# NPM
run "yarn init -y"
run "yarn add esbuild react react-dom"

# rubocop:disable Layout/LineLength
run "npm set-script build 'esbuild app/javascript/*.* --bundle --sourcemap --loader:.js=jsx --outdir=app/assets/javascripts'"
# rubocop:enable Layout/LineLength
#
# Foreman
run "gem install foreman"
run 'echo "#!/usr/bin/env bash\nforeman start -f Procfile.dev "$@"" > bin/dev'
run "echo 'web: bin/rails server -p 3000\njs: yarn build --watch' > Procfile.dev"
run "chmod u+x bin/dev"

# Component Helper from Ruby on Rails
inject_into_file "app/helpers/application_helper.rb", after: "module ApplicationHelper" do
  <<~RB

    def react_component(component_name, **props)
      tag.div(data: {
                react_component: component_name,
                props: props.to_json
              }) { '' }
    end
  RB
end

# Include JS to application.html.erb
inject_into_file "app/views/layouts/application.html.erb", after: "<%= javascript_importmap_tags %>" do
  <<~ERB

    <%= javascript_include_tag "application", "data-turbo-track": "reload", defer: true %>
  ERB
end

# Component Mounter for JS
create_file "app/javascript/mount.js" do
  <<~JAVASCRIPT
    import React from 'react';
    import ReactDOM from 'react-dom';

    export default function mount(components = {}) {
      const mountPoints = document.querySelectorAll('[data-react-component]');
      mountPoints.forEach((mountPoint) => {
        const { dataset } = mountPoint;
        const componentName = dataset.reactComponent;
        const Component = components[componentName];

        if (Component) {
          const props = JSON.parse(dataset.props);
          ReactDOM.render(<Component {...props} />, mountPoint);
        }
      });
    }
  JAVASCRIPT
end

# Example React Component
create_file "app/javascript/components/hello.jsx" do
  <<~JAVASCRIPT
    import React from "react";

    const Hello = () => <div>HELLO WORLD!</div>

    export default Hello;
  JAVASCRIPT
end

# rubocop:disable Layout/LineLength
# Application JS file update
inject_into_file "app/javascript/application.js",
                 after: "// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails" do
  <<~JAVASCRIPT

    // Components
    import Hello from "./components/hello"

    // Component Mounter
    import mount from './mount'

    // Mount Components
    mount({ Hello });
  JAVASCRIPT
end
# rubocop:enable Layout/LineLength

run "yarn build"

# Example Page for Component Test
rails_command "g controller Home index"
inject_into_file "app/views/home/index.html.erb", after: "<p>Find me in app/views/home/index.html.erb</p>" do
  <<~ERB

    <%= react_component "Hello" %>
  ERB
end

puts "React is installed! You can run bin/dev then go to home/index and see the Hello World component."
