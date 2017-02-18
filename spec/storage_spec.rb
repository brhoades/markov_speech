require 'spec_helper'

describe MarkovSpeech::Storage do
  let(:subject) { Markov::Storage::Storage}

  it 'creates new messages' do
    msg = subject.store("test")

    expect(msg).to be_a(Source)
    expect(msg.text).to eq("test")
  end
end
