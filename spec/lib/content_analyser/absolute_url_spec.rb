require 'spec_helper'

describe Cms::ContentAnalyser::AbsoluteUrl do
  it 'returns absoute url' do
    expect(Cms).to receive(:host).and_return('https://example.com')

    analyser = Cms::ContentAnalyser::AbsoluteUrl.new('# some header')
    expect(analyser.run).to eq('https://example.com/some-header')
  end

  it 'return nothing if title wasnt extracted' do
    analyser = Cms::ContentAnalyser::AbsoluteUrl.new('some text')
    expect(analyser.run).to eq(nil)
  end
end
