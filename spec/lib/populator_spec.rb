require 'spec_helper'

describe Cms::Populator do
  class Article < ActiveRecord::Base
    include Cms::Populator

    populate :name, with: Cms::PagePropPopulator::Title, from: :body
    populate :title, with: Cms::PagePropPopulator::Title, from: :body, unless: :test?
    populate :breadcrumb_name, with: Cms::PagePropPopulator::Title, from: :body, if: :test?
    populate with: Cms::PagePropPopulator::Title, from: :body do |text, model|
      if text
        model.slug = '/'+text.split.join
      end
    end
  end

  before :all do
    Article.connection.create_table :articles, force: true do |t|
      t.string :title
      t.string :name
      t.string :breadcrumb_name
      t.string :slug
      t.string :body
      t.boolean :test, default: false
    end
  end

  after :all do
    Article.connection.drop_table :articles
  end

  describe '.populate' do
    let(:model) { Article.new }

    it 'populates attributes using provided content' do
      model.body = '# some title'
      expect {model.save}.to change {model.title}.from(nil).to('some title')
    end

    it 'skips population if we said so' do
      model.body = '# some title'
      model.test = true
      expect {model.save}.to_not change {model.title}
    end

    it 'skips population if :from is empty' do
      model.body = nil
      model.title = 'Some title'

      expect {model.save}.to_not change {model.title}
    end

    it 'populates attributes if we said so' do
      model.body = '# some title'
      model.test = true
      expect {model.save}.to change {model.breadcrumb_name}.from(nil).to('some title')
    end

    it 'takes block' do
      model.body = '# some title'
      expect {model.save}.to change {model.slug}.from(nil).to('/sometitle')
    end
  end
end
