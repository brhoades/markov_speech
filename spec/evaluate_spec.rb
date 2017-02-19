require 'spec_helper'

shared_examples_for 'a generic #slice_into_chains test' do
  # expects :array, :n, and :expected
  let(:subject) { Markov::Evaluate::Evaluate }

  it "and return the correct values" do
    expect(subject::slice_into_chains(array, n)).to eq(expected)
  end
end

describe MarkovSpeech::Evaluate do
  describe "#slice_into_chains" do
    context "when array = [0, 1, 2, 3]" do
      context "and n=2" do
        it_should_behave_like 'a generic #slice_into_chains test' do
          let(:array) { [0, 1, 2, 3] }
          let(:n) { 2 }
          let(:expected) { [[0, 1], [1, 2], [2, 3]] }
        end
      end

      context "and n=3" do
        it_should_behave_like 'a generic #slice_into_chains test' do
          let(:array) { [0, 1, 2, 3] }
          let(:n) { 3 }
          let(:expected) { [[0, 1, 2], [1, 2, 3]] }
        end
      end

      context "and n=4" do
        it_should_behave_like 'a generic #slice_into_chains test' do
          let(:array) { [0, 1, 2, 3] }
          let(:n) { 4 }
          let(:expected) { [[0, 1, 2, 3]] }
        end
      end
    end
  end

  describe "#sentence_repitition" do
    let(:subject) { Markov::Evaluate::Evaluate }

    context "when sentence is unique and has no repition it should return 0" do
      let(:sentence) { [1, 2, 3, 4] }
      it { expect(subject::sentence_repitition(sentence)).to eq(0) }
    end

    context "when given [1, 1, 1, 1] it should return 1" do
      let(:sentence) { [1, 1, 1, 1] }
      it { expect(subject::sentence_repitition(sentence)).to eq(1) }
    end

    context "when given [1, 1, 1, 1, 1] it should return 1" do
      let(:sentence) { [1, 1, 1, 1, 1] }
      it { expect(subject::sentence_repitition(sentence)).to eq(1) }
    end

    context "when given [1, 1, 2, 2] it should return 0" do
      let(:sentence) { [1, 1, 2, 2] }
      it { expect(subject::sentence_repitition(sentence)).to eq(0) }
    end

    context "when given [1, 1, 2, 2, 2] it should return 0.5" do
      let(:sentence) { [1, 1, 2, 2, 2] }
      it { expect(subject::sentence_repitition(sentence)).to eq(0.5) }
    end

    context "when given [1, 1, 2, 2, 2] it should return 0.55" do
      # n=2 => 3/5
      # n=3 => 2/4
      # ((3/5) + (2/4))/2 => 0.55
      let(:sentence) { [1, 1, 2, 2, 2, 2] }
      it { expect(subject::sentence_repitition(sentence)).to eq(0.55) }
    end
  end
end
