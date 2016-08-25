require 'spec_helper'

describe Cms::ContentAnalyser::Image do
  it 'searches for image in markdown' do
    analyser = Cms::ContentAnalyser::Image.new('![Image of Yaktocat](https://octodex.github.com/images/yaktocat.png)')
    expect(analyser.run).to eq('https://octodex.github.com/images/yaktocat.png')
  end

  it 'searches for image in html' do
    analyser = Cms::ContentAnalyser::Image.new('<img src="https://octodex.github.com/images/yaktocat.png" alt="Image of Yakotocat">')
    expect(analyser.run).to eq('https://octodex.github.com/images/yaktocat.png')
  end

  it 'searches for image inside other elements' do
    analyser = Cms::ContentAnalyser::Image.new <<-html
<div class="layout">

![Image of Yaktocat](https://octodex.github.com/images/yaktocat.png)
</div>
    html

    expect(analyser.run).to eq('https://octodex.github.com/images/yaktocat.png')
  end

  it 'takes first image' do
    analyser = Cms::ContentAnalyser::Image.new <<-html
![Image of Yaktocat](https://octodex.github.com/images/yaktocat.png)
![Image of Yaktocat 2](https://octodex.github.com/images/yaktocat2.png)
    html

    expect(analyser.run).to eq('https://octodex.github.com/images/yaktocat.png')
  end

  it 'ignores html without headers' do
    analyser = Cms::ContentAnalyser::Image.new('some html')
    expect(analyser.run).to be_nil
  end

  describe '.read' do
    it 'returns image' do
      expect(Cms::ContentAnalyser::Image.read('![Image of Yaktocat](https://octodex.github.com/images/yaktocat.png)')).to eq('https://octodex.github.com/images/yaktocat.png')
    end
  end
end
