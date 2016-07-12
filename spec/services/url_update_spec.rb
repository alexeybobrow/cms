require 'spec_helper'

describe Cms::UrlUpdate do
  describe '.perform' do
    it 'sets name for non persisted primary url' do
      page = build(:page)
      Cms::UrlUpdate.perform(page, '/services')

      expect(page.primary_url.name).to eq('/services')
    end

    it 'makes old url an alias and creates new primary' do
      page = create(:page, url: '/old-primary')
      Cms::UrlUpdate.perform(page, '/new-primary')
      page.save!

      old_primary = Url.where(name: '/old-primary').first

      expect(page.reload.primary_url.name).to eq('/new-primary')
      expect(page.urls.count).to eq(2)
      expect(old_primary).not_to be_primary
      expect(old_primary.page).to eq(page)
    end

    it 'does nothing if name havent changed' do
      page = create(:page, url: '/old-primary')
      Cms::UrlUpdate.perform(page, '/old-primary')
      page.save!

      expect(page.reload.primary_url.name).to eq('/old-primary')
      expect(page.urls.count).to eq(1)
    end

    it 'does not create alias if page is in draft' do
      page = create(:page, url: '/old-primary')
      page.unpublish!
      Cms::UrlUpdate.perform(page, '/new-primary')
      page.save!

      expect(page.reload.primary_url.name).to eq('/new-primary')
      expect(page.urls.count).to eq(1)
    end
  end

end
