# frozen_string_literal: true

require 'simplecov'
require 'active_record'
require 'database_cleaner/active_record'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

SimpleCov.start do
  track_files '/lib/**/*.rb'
  add_filter '/spec/'
end

require 'safe_polymorphic'
load "#{File.dirname(__FILE__)}/support/schema.rb"
require "#{File.dirname(__FILE__)}/support/models.rb"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
