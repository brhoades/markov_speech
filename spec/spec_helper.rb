$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'markov_speech'
require "active_record"
require "sqlite3"
require 'database_cleaner'

require 'active_record'
require 'active_record/fixtures'
require 'active_support'

require_relative "../environment.rb"

# Setup database connection
environment = "test"
configuration = YAML::load(File.open('spec/database.yml'))
ActiveRecord::Base.establish_connection(configuration[environment])

RSpec.configure do |config|
  # config.fixture_path = File.expand_path("../../test/fixtures", __FILE__)

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  # Run each test inside a DB transaction
  config.around(:each) do |test|
    ActiveRecord::Base.transaction do
      test.run
      raise ActiveRecord::Rollback
    end
  end
end
