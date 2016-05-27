require 'spec_helper'
require 'cms'

describe Cms::Liquid::Tags::Fragment do
  include ActionView::TestCase::Behavior

  def view
    _view.extend Cms::LiquidHelper
    _view.extend Cms::FormattingHelper
    _view
  end

  let(:expected_markup) { "<p>Copyright Anadea</p>\n" }
  let(:env) { OpenStruct.new(environments: [{ view: view }]) }

  before do
    create :fragment, slug: 'footer', content_body: 'Copyright Anadea'
  end

  describe '.render' do
    it 'prints fragment content' do
      tag = described_class.parse('fragment', 'footer', '', [])
      expect(tag.render(env)).to eq(expected_markup)
    end

    it 'takes fragment in single quotes' do
      tag = described_class.parse('fragment', "'footer'", '', [])
      expect(tag.render(env)).to eq(expected_markup)
    end

    it 'takes fragment in double quotes' do
      tag = described_class.parse('fragment', '"footer"', '', [])
      expect(tag.render(env)).to eq(expected_markup)
    end

    it 'prints nothing if fragment wasnt found' do
      tag = described_class.parse('fragment', 'non-existent', '', [])
      expect(tag.render(env)).to eq(nil)
    end

    it 'applies markdown filter' do
      create :fragment, slug: 'copy', content_body: '*Copyright Anadea*'
      tag = described_class.parse('fragment', 'copy', '', [])
      expect(tag.render(env)).to eq("<p><em>Copyright Anadea</em></p>\n")
    end

    it 'can use liquid' do
      create :fragment, slug: 'shared', content_body: '{% fragment footer %}'
      tag = described_class.parse('fragment', 'shared', '', [])
      expect(tag.render(env)).to include(expected_markup)
    end
  end
end
