require 'rspec'
require 'capybara/rspec'
require 'capybara/poltergeist'

# Add the 'spec' path in the load path
spec_dir = File.dirname(__FILE__)
$LOAD_PATH.unshift(spec_dir)

# Require all ruby files in the 'support' folder
Dir[File.join(spec_dir, "support/**/*.rb")].each {|f| require f}

Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, {
      js_errors: false                                 
    })
end

# RSpec config here
RSpec.configure do |config|

  # Capybara config here
  Capybara.configure do |capybara|
    # Don't run a rack app
    capybara.run_server = false

    capybara.default_driver = :poltergeist
    capybara.javascript_driver = :poltergeist
  end

  # Don't forget to tell to RSpec to include Capybara :)
  config.include Capybara::DSL
end
