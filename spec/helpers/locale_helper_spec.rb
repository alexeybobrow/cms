require 'spec_helper'

describe LocaleHelper do
  describe '#translated_path' do
    it 'returns root path if page is nil' do
      expect(helper.translated_path(nil, 'en')).to eq('/')
    end

    it 'returns localized root path if page is nil' do
      expect(helper.translated_path(nil, 'ru')).to eq('/ru')
    end

    it 'returns translated page url' do
      page = create(:page, url: '/test')
      create(:page, url: '/ru/test')
      expect(helper.translated_path(page, 'ru')).to eq('/ru/test')
    end

    it 'returns root path if page does not have translations' do
      page = create(:page, url: '/only/en')
      expect(helper.translated_path(page, 'en')).to eq('/')
    end
  end
end
