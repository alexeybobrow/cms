require 'spec_helper'

describe Cms::PropExtractor::PageType do
  let(:model) { FakeModel.new }
  let(:content) { '/some-url' }

  it 'works with url content' do
    exrtractor_instance = Cms::PropExtractor::PageType.new(model, :title, content)
    expect(exrtractor_instance.text).to eq('website')
  end

  describe '.analyse' do
    let(:prop_extractor) { Cms::PropExtractor::PageType }

    it 'returns text' do
      expect(prop_extractor.analyse('/some-url')).to eq('website')
    end

    it 'reacts to blog urls' do
      expect(prop_extractor.analyse('/blog/some-url')).to eq('article')
    end

    it 'works with empty content' do
      expect(prop_extractor.analyse(nil)).to be_nil
    end
  end
end

