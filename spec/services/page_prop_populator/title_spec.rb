require 'spec_helper'

class FakeModel < Struct.new(:title)
  def update_attribute(name, value)
    self[name] = value
  end
end

describe Cms::PagePropPopulator::Title do
  let(:model) { FakeModel.new }
  let(:content) { '# some title' }
  let(:populator) { Cms::PagePropPopulator::Title.new(model, :title, content) }

  it 'uses analyser to extract text' do
    expect(populator.text).to eq('some title')
  end

  it 'updates model attribute' do
    expect {populator.populate}.to change {model.title}.from(nil).to('some title')
  end
end
