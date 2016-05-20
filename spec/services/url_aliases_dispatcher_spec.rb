require 'spec_helper'

describe Cms::UrlAliasesDispatcher do
  let!(:page) { create :page, url: '/home-page' }

  subject { Cms::UrlAliasesDispatcher.new('') }

  before do
    page.urls.create(name: '/home-page-alias', primary: false)
  end

  it 'matches primary urls' do
    subject.url = page.primary_url

    subject.dispatch do |result, url|
      expect(result).to eq(:primary)
      expect(url.name).to eq('/home-page')
    end
  end

  it 'matches url aliases' do
    subject.url = page.urls.where(name: '/home-page-alias').first

    subject.dispatch do |result, url|
      expect(result).to eq(:alias)
      expect(url.name).to eq('/home-page-alias')
    end
  end

  it 'matches not found' do
    subject.url = nil

    subject.dispatch do |result|
      expect(result).to eq(:not_found)
    end
  end
end

