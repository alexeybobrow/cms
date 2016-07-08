require 'spec_helper'

describe Cms::ContentAnalyser::Title do
  it 'searches for title in markdown' do
    analyser = Cms::ContentAnalyser::Title.new('# some header')
    expect(analyser.run).to eq('some header')
  end

  it 'searches for title in html' do
    analyser = Cms::ContentAnalyser::Title.new('<h1>some header</h1>')
    expect(analyser.run).to eq('some header')
  end

  it 'searches for title inside other elements' do
    analyser = Cms::ContentAnalyser::Title.new <<-html
<div class="layout">

# some header
</div>
    html

    expect(analyser.run).to eq('some header')
  end

  it 'takes first header' do
    analyser = Cms::ContentAnalyser::Title.new <<-html
# first header
# second header
    html

    expect(analyser.run).to eq('first header')
  end

  it 'ignores headers with lower level' do
    analyser = Cms::ContentAnalyser::Title.new('## some header')
    expect(analyser.run).to be_nil
  end

  it 'ignores html without headers' do
    analyser = Cms::ContentAnalyser::Title.new('some html')
    expect(analyser.run).to be_nil
  end

  describe '.read' do
    it 'returns title' do
      expect(Cms::ContentAnalyser::Title.read('# some header')).to eq('some header')
    end
  end
end

