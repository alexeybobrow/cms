require 'spec_helper'

describe 'admin pages versioning' do
  let!(:user) { create :user }
  let!(:about_us) { create :page, title: 'About us', content_body: 'We are great!' }

  before do
    sign_in user
  end

  describe 'history' do
    it 'shows the history page' do
      visit cms.admin_page_path(about_us)
      click_on 'History'

      expect(current_path).to eq(cms.admin_page_page_versions_path(about_us))
      expect(page).to have_content('History')
    end

    it 'shows the history' do
      visit cms.admin_page_path(about_us)
      click_on 'History'

      expect(page).to have_content('Created by')
    end

    it 'shows edits' do
      visit cms.admin_page_path(about_us)
      within '.meta-panel' do
        click_on 'Edit'
      end
      fill_in 'Title', with: 'About ourselves'
      click_on 'Update Page'
      click_on 'History'

      expect(page).to have_content('Updated by')
      expect(page).to have_content('About us')
      expect(page).to have_content('About ourselves')
    end
  end

  describe 'revert to version' do
    it 'reverts to a specific version' do
      visit cms.admin_page_path(about_us)
      within '.meta-panel' do
        click_on 'Edit'
      end
      fill_in 'Title', with: 'About ourselves'
      click_on 'Update Page'
      click_on 'History'

      about_us.reload
      expect(about_us.title).to eq('About ourselves')
      version = about_us.versions.last
      within "#paper_trail_version_#{version.id}" do
        click_on 'Revert before this change'
      end

      about_us.reload
      expect(about_us.title).to eq('About us')
    end

    it 'revert after deletion' do
      visit cms.admin_page_path(about_us)
      click_on 'Delete'
      click_on 'Destroy Page'
      visit cms.admin_page_path(about_us)
      click_on 'History'

      about_us.reload
      version = about_us.versions.last
      within "#paper_trail_version_#{version.id}" do
        click_on 'Revert before this change'
      end

      about_us.reload
      expect(about_us).not_to be_deleted
      expect(page).not_to have_content('deleted')
    end
  end
end
