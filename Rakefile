require "bundler/gem_tasks"
require "rspec/core/rake_task"

require_relative "environment"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

Bundler::GemHelper.install_tasks

desc "Run migrations"
task :migrate do
  ActiveRecord::Migrator.migrate("db/migrations", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
end

task :testmigrate do
  configuration = YAML::load(File.open('spec/database.yml'))
  ActiveRecord::Base.establish_connection(configuration['test'])
end
