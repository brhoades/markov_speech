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

    context "and there are only a couple of identical source texts" do
      it 'the generated output is identical with two identical source texts' do
        original = "test1 test2 test3"
        Markov::Storage::Storage.process(Markov::Storage::Storage.store(original))
        Markov::Storage::Storage.process(Markov::Storage::Storage.store(original))

        expect(subject.chain("test2")).to eq(original)
      end

      it 'the generated output is identical with several identical source texts' do
        original = "test1 test2 test3"
        Markov::Storage::Storage.process(Markov::Storage::Storage.store(original))
        Markov::Storage::Storage.process(Markov::Storage::Storage.store(original))
        Markov::Storage::Storage.process(Markov::Storage::Storage.store(original))
        Markov::Storage::Storage.process(Markov::Storage::Storage.store(original))
        Markov::Storage::Storage.process(Markov::Storage::Storage.store(original))

        expect(subject.chain("test3")).to eq(original)
      end
    end

    context "and there are two source options which complete each other" do
      context "and chain length is equal to their size" do
        before do
          originals = [
            "0 1 2 3 4 5 6",
            "6 7 8 9 10"
          ]
          originals.map { |original|
            Markov::Storage::Storage.process(Markov::Storage::Storage.store(original))
          }
        end

        it 'the generated output is the complete string when starting from the beginning' do
          expect(subject.chain("0")).to eq("0 1 2 3 4 5 6 7 8")
        end

        it 'the generated output is the complete string when starting from the end' do
          expect(subject.chain("6")).to eq("0 1 2 3 4 5 6 7 8")
        end

        it 'the generated output is the complete string when starting from the middle' do
          expect(subject.chain("6")).to eq("0 1 2 3 4 5 6 7 8")
        end
      end

      context "and chain length is smaller than their size" do
        let(:originals) { [
                            "3 4 5 6 7 8 9 10",
                            "11 12 13 14 15 16"
                          ] }

        let(:full) { "3 4 5 6 7 8 9 10 11 12 13 14 15 16" }

        before do
          originals.map { |original|
            Markov::Storage::Storage.process(Markov::Storage::Storage.store(original))
          }
        end

        it 'the generated output is the first original starting from the beginning' do
          expect(subject.chain("3")).to eq(original.first)
        end

        it 'the generated output is the second original startin from the end' do
          expect(subject.chain("16")).to eq(original.last)
        end

        it 'the generated output is the complete string when starting from the middle' do
          expect(subject.chain("10")).to eq(full)
        end

        it 'the generated output is the complete string when starting from other spots in the string' do
          ["4", "5", "6", "7", "8", "9", "11", "12", "13", "14", "15"].each do |start|
            expect(subject.chain(start)).to eq(full)
          end
        end
      end
    end
  end
end
