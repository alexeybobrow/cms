require 'spec_helper'

describe Cms::UrlHelper do
  let(:helper) { Cms::UrlHelper }

  describe '#normalize_url' do
    it ('converts any value to string') do
      expect(helper.normalize_url(nil)).to eq '/'
    end

    it ('trims whitespaces') do
      expect(helper.normalize_url('/excess whitespaces containing string   ')).to eq '/excess whitespaces containing string'
    end

    it ('is case-sensitive') do
      # RFC 7230, section 2.7.3:
      # The scheme and host are case-insensitive and normally provided in lowercase;
      # all other components are compared in a case-sensitive manner.
      expect(helper.normalize_url('/CrAZyCaSeD_StRiNg')).to_not eq '/crazycased_string'
    end


    it 'prepends slash if missing' do
      expect(helper.normalize_url 'any_string').to eq('/any_string')
    end

    it 'does not prepend slash if present' do
      expect(helper.normalize_url '/any_string').to eq('/any_string')
    end

    it 'trims trailing slash if present' do
      expect(helper.normalize_url '/any_string/').to eq('/any_string')
    end
  end

  describe '#url_without_locale' do
    it ('/path/to/page => /path/to/page') do
      expect(helper.url_without_locale('/path/to/page')).to eq '/path/to/page'
    end

    it ('/ru/path/to/page => /path/to/page') do
      expect(helper.url_without_locale('/ru/path/to/page')).to eq '/path/to/page'
    end

    it ('/path/to/ru/page => /path/to/ru/page') do
      expect(helper.url_without_locale('/path/to/ru/page')).to eq '/path/to/ru/page'
    end

    it ('/ruby-on-rails => /ruby-on-rails') do
      expect(helper.url_without_locale('/ruby-on-rails')).to eq '/ruby-on-rails'
    end

    it ('/ru => /') do
      expect(helper.url_without_locale('/ru')).to eq '/'
    end

    it ('/ => /') do
      expect(helper.url_without_locale('/')).to eq '/'
    end
  end

  describe '#locale_from_url' do
    it ('/ru/path/to/page => ru') do
      expect(helper.locale_from_url('/ru/path/to/page')).to eq 'ru'
    end

    it ('/ru => ru') do
      expect(helper.locale_from_url('/ru')).to eq 'ru'
    end

    it ('/ruby-on-rails => nil') do
      expect(helper.locale_from_url('/ruby-on-rails')).to eq nil
    end

    it ('/ => nil') do
      expect(helper.locale_from_url('/')).to eq nil
    end
  end

  describe '#compose_url' do
    it ('(ru, /url) => /ru/url') do
      expect(helper.compose_url('ru','/url')).to eq '/ru/url'
    end

    it ('(en, /url) => /url') do
      expect(helper.compose_url('en','/url')).to eq '/url'
    end

    it ('(en, /ru/url) => /url') do
      expect(helper.compose_url('en','/ru/url')).to eq '/url'
    end

    it ('(ru, /en/url) => /ru/url') do
      expect(helper.compose_url('ru','/en/url')).to eq '/ru/url'
    end

    it ('(ru, /ru/url) => /ru/url') do
      expect(helper.compose_url('ru','/ru/url')).to eq '/ru/url'
    end
  end

  describe '#parent_url' do
    it 'works for one level url' do
      expect(helper.parent_url('/about')).to eq('')
    end

    it 'works for deeply nested url' do
      expect(helper.parent_url('/path/to/page')).to eq('/path/to')
    end

    it 'returns empty string for root url' do
      expect(helper.parent_url('/')).to eq('')
    end
  end
end
