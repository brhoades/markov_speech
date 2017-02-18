require_relative '../../environment.rb'
require_relative 'processing.rb'

module Markov
  module Storage
    class Storage
      include Markov::Storage::Processing

      def self.store(message)
        src = Source.new(text: message)
        src.save!

        src
      end

      def self.process(source)
        sentence = Processor.sever(source.text)

        sentence_p = []
        sentence.each do |word|
          w = Word.find_or_create_by(text: word)

          sentence_p << w
        end

        last = nil
        # This word
        # Word this
        # { text: word, next: nil }, {text: this, next: <-- }
        sentence_p.reverse.each_with_index do |word, i|
          last = Chain.new("next": last, word: word, source: source)
          last.save!
        end
      end
    end
  end
end
