gempath = File.expand_path(File.join(__FILE__, "../../.."))

require "#{gempath}/environment.rb"

desc "Run migrations"
task :migrate do
  path = File.expand_path("#{gempath}/db/migrations")
  puts "Running migrations in: '#{path}'"
  ActiveRecord::Migrator.migrate(path, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
end
