module Markov
  module Generate
    class Generate
      def initialize(chain_length=5, max_in_dir=20)
        @sentence = []
        @chain_length = chain_length

        @current_source = nil
        @current_source_remaining = 0
        @dir = :RIGHT
        @max_in_dir = max_in_dir
        @max_in_dir_remaining = @max_in_dir
      end

      def chain(seed_word, chain_length=5)
        return "" if seed_word == ""
        word = Word.where(text: seed_word)

        if word.size == 0
          return "Unknown word"
        end

        # Randomly choose first chain
        @sentence << get_chain(word.first)

        # First chain is half length as we return to it for the
        # first portion
        @current_source_remaining = @chain_length / 2

        chain_loop
        @sentence
      end

      def to_s
        sent = @sentence.map { |c| c.word.text }.join(" ")
        sent.gsub(/\s([;\:,\.\!\?]{1})/, '\1')
      end

      private
      def get_chain(word)
        chains = Chain.where(word: word)
        chain = chains.offset(rand(chains.count)).first

        @current_source = chain.source
        @current_source_remaining = @chain_length

        chain
      end

      def get_current_source
        return if @current_source_remaining > 0

        @current_source_remaining = @chain_length
        if @dir == :RIGHT
          get_chain(@sentence.last.word)
        elsif @dir == :LEFT
          get_chain(@sentence.first.word)
        end
      end

      def chain_loop
        while @dir != :DONE
          if @dir == :RIGHT
            chain_right
          elsif @dir == :LEFT
            chain_left
          end
        end
      end

      def chain_right
        get_current_source
        @current_source_remaining -= 1

        chains = Chain.where(word: @sentence.last.word, source: @current_source)
        if chains.size > 0 and chains.first.next != nil and @max_in_dir_remaining != 0
          @sentence << chains.first.next
          @max_in_dir_remaining -= 1
        else
          @dir = :LEFT
          @max_in_dir_remaining = @max_in_dir

          # When we flip, use our original source for a while. This
          # spreads out the chain source points from the center.
          @current_source = @sentence.first.source
          @current_source_remaining = @chain_length / 2
          return
        end
      end

      def chain_left
        get_current_source
        @current_source_remaining -= 1

        chains = Chain.where(source: @current_source, "next": Chain.where(source: @current_source, word: @sentence.first.word))
        if chains.size > 0 and @max_in_dir_remaining != 0
          @sentence.unshift(chains.first)
          @max_in_dir_remaining -= 1
        else
          @dir = :DONE
          return
        end
      end
    end
  end
end
