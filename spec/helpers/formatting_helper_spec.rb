require 'spec_helper'

describe Cms::FormattingHelper do
  describe '.remove_tags' do
    it 'removes unclosed img tags' do
      expect(helper.remove_tags('<img src="#" />Sample text')).to eq('Sample text')
      expect(helper.remove_tags('<a href="#"><img src="#" />Sample text</a>')).to eq('<a href="#">Sample text</a>')
    end

    it 'removes closed tags' do
      expect(helper.remove_tags('<h1>Sample text</h1>Sample text')).to eq('Sample text')
    end

    it 'removes link with unclosed img tag' do
      expect(helper.remove_tags('<a href="#"><img src="#" /></a>Sample text')).to eq('Sample text')
    end

    it 'removes p with link with unclosed img tag' do
      expect(helper.remove_tags('<p><a href="#"><img src="#" /></a></p>Sample text')).to eq('Sample text')
    end

    it 'removes p with link with img tag' do
      expect(helper.remove_tags('<p><a href="#"><img src="#"></img></a></p>Sample text')).to eq('Sample text')
    end

    it 'removes ul tags' do
      expect(helper.remove_tags('<ul><li>List item</li></ul>Sample text')).to eq('Sample text')
    end

    it 'removes ul tags in multiline string' do
      sample_html = <<-html
<h1>Heading</h1>
<ul>
  <li>List item</li>
</ul>
Sample text
      html

      expect(helper.remove_tags(sample_html).strip).to eq("Sample text")
    end

    it 'removes tags from different places in html' do
      sample_html = <<-html
<h1>Heading</h1>
Sample text
<h1>Heading</h1>
      html

      expect(helper.remove_tags(sample_html).strip).to eq("Sample text")
    end
  end
end
