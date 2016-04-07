require 'spec_helper'

describe Cms::Liquid::Tags::Author do
  let(:author_markup) { "<a href='/blog/author/kent-beck'>Kent Beck</a>" }

  describe '.render' do
    it 'draws author filter link' do
      rendered = described_class.parse('author', 'Kent Beck', '', []).render({})
      expect(rendered).to eq(author_markup)
    end
  end
end
