# environment.rb
# recursively requires all files in ./lib and down that end in .rb
require "active_record"
require "sqlite3"


Dir.glob('./lib/*').each do |folder|
  Dir.glob("#{folder}/*.rb").each do |file|
    require file
  end
end

# Discover Models
Dir["#{File.expand_path(".")}/lib/**/models/*.rb"].each do |f|
  puts "Loaded model #{f}"
  require f
end

ActiveRecord::Base.logger = Logger.new('db/logs/debug.log')
# configuration = YAML::load(IO.read('database.yml'))
# ActiveRecord::Base.establish_connection(configuration['development'])

# tells AR what db file to use
ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'markov.db'
)
