require 'spec_helper'

describe Cms::ContentAnalyser::Url do
  it 'returns slug' do
    analyser = Cms::ContentAnalyser::Url.new('# some header')
    expect(analyser.run).to eq('some-header')
  end

  it 'works with russian text' do
    analyser = Cms::ContentAnalyser::Url.new('# какой-то заголовок')
    expect(analyser.run).to eq('kakoi-to-zagolovok')
  end
end

