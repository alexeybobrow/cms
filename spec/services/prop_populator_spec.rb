require 'spec_helper'

describe Cms::PropPopulator do
  class Article < Struct.new(:title, :body, :test)
  end

  describe '.populate' do
    let(:model) { Article.new }
    let(:populator) { Cms::PropPopulator }
    let(:title_extractor) { Cms::PropExtractor::Title }

    it 'populates attributes using provided content' do
      model.body = '# some title'
      populator.populate(model, :title, with: title_extractor, from: :body)
      expect(model.title).to eq('some title')
    end

    it 'skips population if we said so' do
      model.body = '# some title'
      model.test = true
      populator.populate(model, :title, with: title_extractor, from: :body, unless: :test)
      expect(model.title).to be_nil
    end

    it 'populates attributes if we said so' do
      model.body = '# some title'
      model.test = true
      populator.populate(model, :title, with: title_extractor, from: :body, if: :test)
      expect(model.title).to eq('some title')
    end

    it 'skips population if :from is empty' do
      model.body = nil
      model.title = 'Old title'
      populator.populate(model, :title, with: title_extractor, from: :body)
      expect(model.title).to eq('Old title')
    end

    it 'takes block' do
      model.body = '# some title'
      populator.populate(model, :title, with: title_extractor, from: :body) do |text, model|
        model.title = text
      end
      expect(model.title).to eq('some title')
    end
  end
end
