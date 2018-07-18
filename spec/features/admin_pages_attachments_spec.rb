require 'spec_helper'

describe 'admin pages attachments', js: true do
  let!(:user) { create :user }
  let!(:test_page_1) { create :page, title: 'Test page 1',
                                     url: '/page_1_url',
                                     content_body: "put images here!" }

  before do
    sign_in user
    visit cms.admin_pages_path
    click_on 'Test page 1'
    find('.content-panel .btn').click
    page.execute_script("$('input[type=\"file\"]')[0].style.position = 'static'") # attach_file can't set hidden file input (visible: false not work) :(
    page.execute_script("$('input[type=\"file\"]')[0].style.opacity = '1'")
    page.execute_script("$('input[type=\"file\"]')[0].style.fontSize = '15px'")
    page.attach_file('image_attachment[image][]', fixture_file_path('image_1.jpg'))
    expect(page).to have_xpath("//img[contains(@src,'image_1.jpg')]")
    page.attach_file('image_attachment[image][]', fixture_file_path('image_2.png'))
    expect(page).to have_xpath("//img[contains(@src,'image_2.png')]")
  end

  after do
    FileUtils.rm_rf(Dir["spec/rails_app/public/uploads"])
  end

  it 'adds attachments to the page for markdown format' do
    page.select 'markdown', from: 'Markup language'
    page.find(:xpath,"//img[contains(@src,'image_1.jpg')]").click
    page.find(:xpath,"//img[contains(@src,'image_2.png')]").click
    click_on 'Update Content'
    visit '/page_1_url'
    expect(page).to have_xpath("//img[contains(@src,'image_1.jpg')]")
    expect(page).to have_xpath("//img[contains(@src,'image_2.png')]")
  end

  it 'adds attachments to the page for html format' do
    page.select 'html', from: 'Markup language'
    page.find(:xpath,"//img[contains(@src,'image_1.jpg')]").click
    page.find(:xpath,"//img[contains(@src,'image_2.png')]").click
    click_on 'Update Content'
    visit '/page_1_url'
    expect(page).to have_xpath("//img[contains(@src,'image_1.jpg')]")
    expect(page).to have_xpath("//img[contains(@src,'image_2.png')]")
  end

  it 'delete an attachment from the page' do
    page.find(:xpath,"//img[contains(@src,'image_1.jpg')]").click
    page.find(:xpath, "//div[@class='file-name']/a[contains(text(),'image_1.jpg')]/../../div[@class='description']//*[@value='Delete' or contains(text(), 'Delete')]").click
    expect(page).to_not have_xpath("//img[contains(@src,'image_1.jpg')]")
    click_on 'Update Content'
    visit '/page_1_url'
    expect(page).to have_xpath("//img[contains(@src,'image_1.jpg')]")
    visit page.find(:xpath,"//img[contains(@src,'image_1.jpg')]")['src']
    expect(page.status_code).to be 404
  end

  it 'changes main attachment' do
    content = test_page_1.content.reload
    expect(content.attachments.size).to eq(2)

    expect(page).to have_xpath("//div[@class='file-name']/a[contains(text(),'image_1.jpg')]/../../div[@class='description']/div[@class='is_header']//*[@value='Header image' or contains(text(), 'Header image')]")
    expect(page).to have_xpath("//div[@class='file-name']/a[contains(text(),'image_2.png')]/../../div[@class='description']/div[@class='is_header']//*[@value='Set as header image' or contains(text(), 'Set as header image')]")
    expect(content.main_image.image.file.filename).to eq('image_1.jpg')

    click_on 'Set as header image'

    expect(page).to have_xpath("//div[@class='file-name']/a[contains(text(),'image_1.jpg')]/../../div[@class='description']/div[@class='is_header']//*[@value='Set as header image' or contains(text(), 'Set as header image')]")
    expect(page).to have_xpath("//div[@class='file-name']/a[contains(text(),'image_2.png')]/../../div[@class='description']/div[@class='is_header']//*[@value='Header image' or contains(text(), 'Header image')]")
    expect(content.reload.main_image.image.file.filename).to eq('image_2.png')
  end
end
