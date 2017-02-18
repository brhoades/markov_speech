require_relative '../../environment.rb'
require_relative 'sever.rb'

module Markov
  module Storage
    class Storage
      include Markov::Storage::Processing

      def self.store(message)
        src = Source.new(text: message)
        src.save!

        src
      end

      private
      def self.process(source)
        sentences = sever(source.text)

        sentences.map! do |sentence|
          sentence.map! do |word|
            Word.first_or_initialize(word) { |w| w.save! }
          end
        end
        sentence.flatten!

        sentences.each_with_index do |word, i|
          next_word = nil

          if i != sentences.size - 1
            next_word = sentences[i + 1]
          end

          Chain.new("next": next_word, source: source)
        end
      end
    end
  end
end
