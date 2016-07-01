require 'spec_helper'

describe Cms::Populator do
  class Article < ActiveRecord::Base
    include Cms::Populator

    populate :name, with: Cms::PagePropPopulator::Title, from: :body
    populate :title, with: Cms::PagePropPopulator::Title, from: :body, unless: :override_title?
  end

  before :all do
    Article.connection.create_table :articles, force: true do |t|
      t.string :title
      t.boolean :override_title, default: false
      t.string :name
      t.string :body
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
      model.override_title = true
      expect {model.save}.to_not change {model.title}
    end
  end
end
