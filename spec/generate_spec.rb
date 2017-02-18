require 'spec_helper'

describe MarkovSpeech::Generate do
  let(:subject) { Markov::Generate::Generate.new }

  context "when #chain is called" do
    context "and there is only a single source text" do
      it 'the generated output is identical with a large sentence' do
        original = "test1 test2 test3 test4 test5 test6 test7"
        msg = Markov::Storage::Storage.store(original)
        Markov::Storage::Storage.process(msg)

        expect(subject.chain("test2")).to eq(original)
      end

      it 'the generated output is identical with a single word' do
        original = "test1"
        msg = Markov::Storage::Storage.store(original)
        Markov::Storage::Storage.process(msg)

        expect(subject.chain("test1")).to eq(original)
      end

      it 'the generated output is identical with a pair, with the first word as an input' do
        original = "test1 test2"
        msg = Markov::Storage::Storage.store(original)
        Markov::Storage::Storage.process(msg)

        expect(subject.chain("test1")).to eq(original)
      end

      it 'the generated output is identical with a pair, with the second word as an input' do
        original = "test1 test2"
        msg = Markov::Storage::Storage.store(original)
        Markov::Storage::Storage.process(msg)

        expect(subject.chain("test2")).to eq(original)
      end

      it 'the generated output is identical with an empty string' do
        original = ""
        msg = Markov::Storage::Storage.store(original)
        Markov::Storage::Storage.process(msg)

        expect(subject.chain("")).to eq(original)
      end
    end
  end
end
