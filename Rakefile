require "bundler/gem_tasks"
require "rspec/core/rake_task"

require_relative "environment"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

Bundler::GemHelper.install_tasks

import "./lib/tasks/database.rake"

task :testmigrate do
  configuration = YAML::load(File.open('spec/database.yml'))
  ActiveRecord::Base.establish_connection(configuration['test'])
end
