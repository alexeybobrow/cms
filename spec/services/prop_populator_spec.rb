require 'spec_helper'

describe Cms::PropPopulator do
  let(:page) { create(:page) }

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
    let(:populator) { Cms::PropPopulator::ForPage }

    describe '.populate' do
      it 'populates page fields' do
        page.content.body = '# Some header'

        populator.populate(page)

        expect(page.title).to eq('Some header')
        expect(page.name).to eq('Some header')
        expect(page.breadcrumb_name).to eq('Some header')
      end

      it 'doesnt populate filelds if overrides set to true' do
        page.content.body = '# Some header'

        page.title = 'Old title'
        page.override_title = true

        populator.populate(page)

        expect(page.title).to eq('Old title')
        expect(page.name).to eq('Some header')
      end

      it 'works only when text can be extracted' do
        page.content.body = 'Some header'
        page.title = 'Old title'

        populator.populate(page)
        expect(page.title).to eq('Old title')
      end
    end
  end

  describe Cms::PropPopulator::ForUrl do
    let(:populator) { Cms::PropPopulator::ForUrl }

    describe '.populate' do
      it 'populates url field' do
        page.content.body = '# Some header'
        populator.populate(page)
        expect(page.primary_url.name).to eq('/some-header')
      end

      it 'populates with page id if text wasnt extracted' do
        page.content.body = 'Some text'
        populator.populate(page)
        expect(page.primary_url.name).to eq("/#{page.id}")
      end

      it 'adds parent url as prefix' do
        page.content.body = '# Some header'
        page.parent_url = '/blog'
        populator.populate(page)
        expect(page.primary_url.name).to eq('/blog/some-header')
      end

      it 'does nothing if override was set' do
        page.content.body = '# Some header'
        page.primary_url.name = '/some-url'
        page.override_url = true

        populator.populate(page)
        expect(page.primary_url.name).to eq('/some-url')
      end
    end
  end

  describe Cms::PropPopulator::ForPageMeta do
    let(:populator) { Cms::PropPopulator::ForPageMeta }

    before do
      populator.defaults = [] # reset defaults
    end

    describe '.populate' do
      it 'populates meta fields' do
        page.content.body = '# Some header'

        populator.populate(page)
        expect(page.meta).to eq([{'property' => 'og:title', 'content' => 'Some header' }])
      end

      it 'does nothing if override was set' do
        page.content.body = '# Some header'
        page.meta = [{'property' => 'og:title', 'content' => 'Old title' }]
        page.override_meta_tags = true

        populator.populate(page)
        expect(page.meta).to eq([{'property' => 'og:title', 'content' => 'Old title' }])
      end

      it 'fills defaults' do
        expect(populator).to receive(:populate_with_defaults)
        populator.populate(page)
      end

      it 'overrides existing meta' do
        page.content.body = '# Some header'
        page.meta = [{'property' => 'og:title', 'content' => 'Old title' }]

        populator.populate(page)
        expect(page.meta).to eq([{'property' => 'og:title', 'content' => 'Some header' }])
      end

      it 'adds to the existing meta' do
        page.content.body = '# Some header'
        page.meta = [{'property' => 'og:url', 'content' => 'https://anadea.info' }]

        populator.populate(page)
        expect(page.meta).to eq([
          {'property' => 'og:url', 'content' => 'https://anadea.info' },
          {'property' => 'og:title', 'content' => 'Some header' }
        ])
      end
    end

    describe '.populate_with_defaults' do
      before do
        populator.defaults = [{ 'property' => 'twitter:site' } => { 'content' => '@AnadeaInc' }]
      end

      it 'populates meta with provided defaults' do
        populator.populate(page)
        expect(page.meta).to eq([{ 'property' => 'twitter:site', 'content' => '@AnadeaInc' }])
      end

      it 'skips defaults if override was set' do
        page.override_meta_tags = true
        populator.populate(page)
        expect(page.meta).to eq([])
      end
    end

    describe '.configure' do
      it 'allows to modify class variables' do
        populator.configure do |config|
          expect(config).to eq(described_class)
        end
      end
    end
  end
end
