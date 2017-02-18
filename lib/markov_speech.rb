require "markov_speech/version"

require_relative "../environment.rb"
require_relative "generate/generate.rb"
require_relative  "storage/storage.rb"

module MarkovSpeech
  include Markov::Generate
  include Markov::Storage
end
