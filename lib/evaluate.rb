require 'uri'

require_relative '../environment.rb'

require_relative "storage/models/chain.rb"
require_relative "storage/models/word.rb"
require_relative "storage/models/source.rb"

module Markov
  module Evaluate
    class Evaluate
      include Markov::Models

      # Given a sentence, return a number from 0 to 1 representing its quality.
      # 0 is most likey nothing like a real sentence (this may apply to latin languages mostly).
      # 0 can also represent that a sentence is verbatim a source sentence.
      #
      # 1 means meets all criteria for a good sentence.
      #
      # a 0.8 would be a good sentence, while a 0.3 wouldn't be very good.
      #
      # 0.1 -> first word capitalized and not punctuation.
      # 0.1 -> last word is punctuation or a link.
      # 0.1 -> (# of punctuation chars with capital trailing / # of punctuation chars)/10
      def self.eval(sentence)
        score = 0

        # Check if a sentence is a source sentence.
        return score if Source.where(text: sentence.to_s).size > 0

        # First word is capitalized / not punctuation.
        if sentence.first.word.text.capitalize == sentence.first.word.text and sentence.first.word.to_s !~ /^[[:punct:]]+$/
          score += 0.1
        end

        # Last word is punctuation or a link
        if sentence.last.word.text =~ /[[:punct"]]+$/ or sentence.last.word.text =~ URI::regexp
          score += 1
        end

        if sentence =~ /[\.\?\!]+\s*[A-Za-z]/
          score += (sentence.to_s.scan(/([\.\?\!]+\s*[A-Z])/).size / sentence.to_s.scan(/([\.\?\!]+\s*[a-zA-Z])/).size) / 10
        else
          score += 0.1
        end
      end
    end
  end
end
