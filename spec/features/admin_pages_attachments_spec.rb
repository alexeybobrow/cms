require 'spec_helper'

describe 'admin pages attachments' do
  before do
    skip "Haven't been visited for a while"
  end

  let!(:user) { create :user }
  let!(:test_page_1) { create :page, title: 'Test page 1',
                                     url: 'page_1_url',
                                     content_body: "put images here!" }

  context 'management', js: true do
    before do
      sign_in user
      visit cms.admin_pages_path
      click_on 'Test page 1'
      click_on 'Edit'
      page.attach_file('image_attachment_image', fixture_file_path('image_1.jpg', 'image_2.png'))
    end

    it 'adds attachments to the page for markdown format' do
      expect(page).to have_xpath("//img[contains(@src,'image_1.jpg')]")
      expect(page).to have_xpath("//img[contains(@src,'image_2.png')]")
      page.select 'markdown', from: 'Format'
      page.find(:xpath,"//img[@alt='image_1.jpg']").click
      page.find(:xpath,"//img[@alt='image_2.png']").click
      click_on 'Update Page'
      visit '/page_1_url'
      expect(page).to have_xpath("//img[contains(@src,'image_1.jpg')]")
      expect(page).to have_xpath("//img[contains(@src,'image_2.png')]")
    end

    it 'adds attachments to the page for html format' do
      page.select 'html', from: 'Format'
      page.find(:xpath,"//img[@alt='image_1.jpg']").click
      page.find(:xpath,"//img[@alt='image_2.png']").click
      click_on 'Update Page'
      visit '/page_1_url'
      expect(page).to have_xpath("//img[contains(@src,'image_1.jpg')]")
      expect(page).to have_xpath("//img[contains(@src,'image_2.png')]")
    end

    it 'delete an attachment from the page' do
      page.find(:xpath,"//img[@alt='image_1.jpg']").click
      delete_image('image_1.jpg')
      assert_image_deleted('image_1.jpg')
      click_on 'Update Page'
      visit '/page_1_url'
      expect(page).to have_xpath("//img[contains(@src,'image_1.jpg')]")
      visit page.find("img[@alt='image_1.jpg']")['src']
      expect(page.status_code).to be 404
    end

    it 'delete and restore an attachment on the page' do
      page.find(:xpath,"//img[@alt='image_1.jpg']").click
      delete_image('image_1.jpg')
      assert_image_deleted('image_1.jpg')
      restore_image('image_1.jpg')
      assert_image_restored('image_1.jpg')
      click_on 'Update Page'
      visit '/page_1_url'
      expect(page).to have_xpath("//img[contains(@src,'image_1.jpg')]")
      visit page.find("img[@alt='image_1.jpg']")['src']
      expect(page.status_code).to be 200
    end
  end

  context 'management (without js)' do
    it 'adds attachments to the existing page' do
      sign_in user
      visit admin_users_path
      click_on 'Test page 1'
      click_on 'Edit'
      page.attach_file('image_attachment_image', fixture_file_path('image_1.jpg', 'image_2.png'))
      click_on "Upload Files"
      expect(page).to have_xpath("//img[contains(@src,'image_1.jpg')]")
      expect(page).to have_xpath("//img[contains(@src,'image_2.png')]")
      delete_image('image_1.jpg')
      expect(page).not_to have_xpath("//img[contains(@src,'image_1.jpg')]")
      expect(page).to have_xpath("//img[contains(@src,'image_2.png')]")
    end

    it 'adds attachments to the new page' do
      sign_in user
      visit admin_users_path
      click_on 'Create a new page'
      page.attach_file('image_attachment_image', fixture_file_path('image_1.jpg', 'image_2.png'))
      click_on "Upload Files"
      delete_image('image_1.jpg')
      expect(page).not_to have_xpath("//img[contains(@src,'image_1.jpg')]")
      expect(page).to have_xpath("//img[contains(@src,'image_2.png')]")
      page.attach_file('image_attachment_image', fixture_file_path('image_1.jpg'))
      click_on "Upload Files"
      expect(page).to have_xpath("//img[contains(@src,'image_1.jpg')]")
      expect(page).to have_xpath("//img[contains(@src,'image_2.png')]")
      fill_in 'Title', with: 'Created page'
      fill_in 'Url', with: 'created_page'
      fill_in 'Body', with: 'Body of newly created page'
      select 'regular', from: 'page_kind'
      click_on 'Create Page'
      click_on 'Edit'
      expect(page).to have_xpath("//img[contains(@src,'image_1.jpg')]")
      expect(page).to have_xpath("//img[contains(@src,'image_2.png')]")
    end
  end
end
