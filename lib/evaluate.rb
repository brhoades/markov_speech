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
      # 0 is most likely nothing like a real sentence (this may apply to Latin languages mostly).
      # 0 can also represent that a sentence is verbatim a source sentence.
      #
      # 1 means meets all criteria for a good sentence.
      #
      # a 0.8 would be a good sentence, while a 0.3 wouldn't be very good.
      #
      # 0.1 -> first word capitalized and not punctuation.
      # 0.1 -> last word is punctuation or a link.
      # 0.1 -> (# of punctuation chars with capital trailing / # of punctuation chars)/10
      # 0.2 -> Average % of duplicate chain sequences * 0.2.
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
          score += 0.1
        end

        # If we have punctuation which has a following letter, take the total number
        # of these instances and put the number of cases where it's done grammatically corect
        # over that. Divide that by 10 then add it to our score.
        if sentence =~ /[\.\?\!]+\s*[A-Za-z]/
          score += (sentence.to_s.scan(/([\.\?\!]+\s*[A-Z])/).size / sentence.to_s.scan(/([\.\?\!]+\s*[a-zA-Z])/).size) / 10
        else
          score += 0.1
        end

        score += (1 - sentence_repitition(sentence)) * 0.2

        # Stretch the score until I find more metrics
        score / 0.5
      end

      # Return an average percentage of duplicate chain sequences from n=2 to sentence.size / 2.
      #
      #----- Examples
      # For example (w/ n=3):
      #   [5, 6, 2, 3, 2, 1, 3, 2, 1, 2, 2]
      # Duplicate sequences:
      #   [3, 2, 1] (2 count)
      # Get the number of nonduplicate sequences of this count:
      #   [5, 6, 2], [6, 2, 3], [2, 3, 2], [2, 1, 3]
      #   [1, 3, 2], [2, 1, 2], [1, 2, 2] (7 count)
      # Then: (duplicate sequences) / (all sequences) (2/7)
      #
      # This is then repeated up to half the # of chains. That amount is averaged
      # and returned (and is [0,1]).
      #
      def self.sentence_repitition(sentence)
        max = sentence.size / 2
        splits = (2..max).to_a
        sum = 0

        splits.each do |n|
          all = slice_into_chains(sentence, n)
          dups = all.dup  # copy

          # Remove the first instance of all elements. Only the "duplicates"
          # will remain in the source array.
          #
          # [1, 1, 1, 2] => [1, 1, 1]
          dups.uniq.map { |e| dups.delete_at(dups.find_index(e)) if dups.count(e) == 1 }

          sum += dups.size.to_f / all.size
        end

        sum / splits.size
      end

      # slice_into_chains(Array array, Integer n)
      #
      # Given an array, slice it into n-sized array.
      #
      #---- Examples
      # array = [1, 2, 3, 4]
      # n = 2
      #
      # $ slice_into_chains(array, n)
      # => [[1, 2], [2, 3], [3, 4]]
      #
      # array = [1, 2, 3, 4, 5, 6]
      # n = 3
      #
      # $ slice_into_chains(array, n)
      # => [[1, 2, 3], [2, 3, 4], [3, 4, 5], [4, 5, 6]]
      def self.slice_into_chains(array, n)
        chunks = []

        array.each_with_index do |_, i|
          break if i + n > array.size

          thischunk = []

          n.times.each do |j|
            thischunk << array[i + j]
          end

          chunks << thischunk
        end

        chunks
      end
    end
  end
end
