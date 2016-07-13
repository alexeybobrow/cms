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

  describe Cms::PropPopulator::ForPage do
    let(:page) { create(:page) }

    it 'populates page fields' do
      page.content.body = '# Some header'

      Cms::PropPopulator::ForPage.populate(page)

      expect(page.title).to eq('Some header')
      expect(page.name).to eq('Some header')
      expect(page.breadcrumb_name).to eq('Some header')
    end

    it 'doesnt populate filelds if overrides set to true' do
      page.content.body = '# Some header'

      page.title = 'Old title'
      page.override_title = true

      Cms::PropPopulator::ForPage.populate(page)

      expect(page.title).to eq('Old title')
      expect(page.name).to eq('Some header')
    end

    it 'works only when text can be extracted' do
      page.content.body = 'Some header'
      page.title = 'Old title'

      Cms::PropPopulator::ForPage.populate(page)
      expect(page.title).to eq('Old title')
    end
  end

  describe Cms::PropPopulator::ForUrl do
    let(:page) { create(:page) }

    it 'populates url field' do
      page.content.body = '# Some header'
      Cms::PropPopulator::ForUrl.populate(page)
      expect(page.primary_url.name).to eq('/some-header')
    end

    it 'populates with page id if text wasnt extracted' do
      page.content.body = 'Some text'
      Cms::PropPopulator::ForUrl.populate(page)
      expect(page.primary_url.name).to eq("/#{page.id}")
    end

    it 'adds parent url as prefix' do
      page.content.body = '# Some header'
      page.parent_url = '/blog'
      Cms::PropPopulator::ForUrl.populate(page)
      expect(page.primary_url.name).to eq('/blog/some-header')
    end

    it 'does nothing if override was set' do
      page.content.body = '# Some header'
      page.primary_url.name = '/some-url'
      page.override_url = true

      Cms::PropPopulator::ForUrl.populate(page)
      expect(page.primary_url.name).to eq('/some-url')
    end
  end
end
