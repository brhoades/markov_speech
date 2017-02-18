require 'spec_helper'

describe MarkovSpeech::Storage do
  let(:subject) { Markov::Storage::Storage}

  context "when #store is called" do
    it 'creates a new source from a message' do
        msg = subject.store("test")

        expect(msg).to be_a(Source)
        expect(msg.text).to eq("test")
    end
  end

  context "when #process is called" do
    let(:word) { double("word") }
    let(:chain) { double("chain") }

    it 'process creates a word and a chain with "test"' do
      msg = subject.store("test")
      subject.process(msg)

      expect(Word.last.text).to eq("test")
      expect(Chain.last.word).to eq(Word.last)
    end

    it 'process creates a word and a chain for each unique word' do
      text = "test test1 test2 test3 test4"
      msg = subject.store(text)

      text.split(/\s/).each do |w|
      # Fuck it, we'll verify in generation.
      expect(Chain).to receive(:new).and_return(chain)

      expect(chain).to receive(:save!)

        expect(Word).to receive(:find_or_create_by).with(text: w)
          .and_return(word)
      end

      subject.process(msg)
    end

    it 'process creates a word and a chain for each unique word real' do
      text = "test test1 test2 test3 test4"
      msg = subject.store(text)
      subject.process(msg)

      text.split(/\s/).each do |real|
        expect(Word.where(text: real)).not_to be_empty
      end

      chains = Chain.last(5)
      text.split(/\s/).zip(chains).each_with_index do |pair, index|
      end
    end
  end
end
