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
      context "and they are small" do
        context do
          let(:originals) {
            [
              "0 1 2",
              "2 3 4"
            ]
          }

          before do
            originals.map { |original|
              Markov::Storage::Storage.process(Markov::Storage::Storage.store(original))
            }

            it 'it stops chaining when it ends the first chain (from the leftmost word)' do
              expect(subject.chain("0")).to eq("0 1 2")
            end

            it 'it stops chaining when it ends the first chain (from the rightmost word)' do
              originals.map { |original|
                Markov::Storage::Storage.process(Markov::Storage::Storage.store(original))
              }

              expect(subject.chain("4")).to eq("2 3 4")
            end
          end
        end

        context do
          let(:originals) {
            [
              "0 1 2 3 4 5",
              "5 6 7 8 9"
            ]
          }

          before do
            originals.map { |original|
              Markov::Storage::Storage.process(Markov::Storage::Storage.store(original))
            }
          end

          it 'it continues chaining when the next chain picks up where the first left off' do
            srand 123333

            expect(subject.chain("0")).to eq("0 1 2 3 4 5 6 7 8 9")
          end

          it 'it continues chaining left when the next chain picks up where the first left off' do
            srand 1233

            expect(subject.chain("9")).to eq("0 1 2 3 4 5 6 7 8 9")
          end
        end
      end
    end
  end
end
