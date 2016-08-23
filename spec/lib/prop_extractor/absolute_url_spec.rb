require 'spec_helper'

describe Cms::PropExtractor::AbsoluteUrl do
  let(:model) { FakeModel.new }
  let(:content) { '# some title' }
  let(:prop_extractor) { Cms::PropExtractor::AbsoluteUrl.new(model, :title, content) }

  before do
    expect(Cms).to receive(:host).and_return('https://example.com')
  end

  it 'uses analyser to extract text' do
    expect(prop_extractor.text).to eq('https://example.com/some-title')
  end

  describe '#populate' do
    it 'updates model attribute' do
      expect {prop_extractor.populate}.to change {model.title}.from(nil).to('https://example.com/some-title')
    end
  end

  describe '.analyse' do
    it 'returns text' do
      prop_extractor = Cms::PropExtractor::AbsoluteUrl
      expect(prop_extractor.analyse('# some title')).to eq('https://example.com/some-title')
    end
  end
end
