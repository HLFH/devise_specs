# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'aruba/cucumber'

Aruba.configure do |config|
  config.exit_timeout = 100
end

Before do
  delete_environment_variable 'RUBYOPT'
  delete_environment_variable 'BUNDLE_GEMFILE'
end
