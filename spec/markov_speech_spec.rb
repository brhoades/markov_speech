require 'spec_helper'

describe MarkovSpeech do
  it 'has a version number' do
    expect(MarkovSpeech::VERSION).not_to be nil
  end

  it 'has a storage class' do
    expect(MarkovSpeech::Storage).to be_a Class
  end

  it 'has a generate class' do
    expect(MarkovSpeech::Generate).to be_a Class
  end
end
