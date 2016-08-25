# encoding: UTF-8

require 'spec_helper'

describe 'admin pages management' do

  let(:text_with_code_block) {
    <<-SRC
```
puts "Hello world!"
```
SRC
  }
  let!(:user) { create :user }
  let!(:test_page) { create :page, name: 'Test page', url: '/page_url' }

  let!(:page_in_russian) { create :page, content_body: 'На русском', url: '/ru/page_with_locale' }
  let!(:page_for_destroy) { create :page, name: 'Bad', url: '/bad_url' }

  before do
    sign_in user
  end

  context 'read' do
    it 'shows pages list' do
      create :page, name: 'Test page 2'
      visit cms.admin_pages_path
      expect(page).to have_content('Test page')
      expect(page).to have_content('Test page 2')
    end

    it 'shows single page' do
      visit admin_users_path
      click_on 'Test page'
      expect(current_path).to eq(cms.admin_page_path(test_page))
      expect(page).to have_content('Test page')
      expect(page).to have_content('/page_url')
    end

    it 'shows deleted notice' do
      page_for_destroy.safe_delete

      visit cms.admin_page_path(page_for_destroy)
      expect(page).to have_content('deleted')
    end

    it 'shows pages names' do
      create(:page, title: 'It is Title', name: 'It is Name')
      visit cms.admin_pages_path

      expect(page).to have_content("It is Name")
      expect(page).not_to have_content("It is Title")
    end
  end

  context 'preview' do
    it 'can visit page with url' do
      create(:page, name: 'Sparta FTW', content_body: 'This is sparta', url: '/sparta')
      visit cms.admin_pages_path

      click_on 'Sparta FTW'
      click_on 'Sparta FTW'

      expect(current_path).to eq("/sparta")
      expect(page).to have_content("This is sparta")
    end

    it 'can visit page without url' do
      sparta_page = create(:page, name: 'Sparta FTW', content_body: 'This is sparta', url: '')
      visit cms.admin_pages_path

      click_on 'Sparta FTW'
      click_on 'Sparta FTW'

      expect(current_path).to eq("/#{sparta_page.id}")
      expect(page).to have_content("This is sparta")
    end
  end

  context 'create' do
    before do
      visit cms.admin_pages_path
    end

    it 'redirects to content edit' do
      click_on 'Create new page'
      expect(page).to have_content('Edit page content')
    end

    it 'creates page with url as id' do
      click_on 'Create new page'
      click_on 'Update Content'
      id = current_path[/\/admin\/pages\/(\d+)/, 1]
      expect(page).to have_content("/#{id}")
    end

    it 'creates page with url from content' do
      click_on 'Create new page'
      fill_in 'Body', with: '# Some title'
      click_on 'Update Content'
      expect(page).to have_content("/some-title")
    end

    it 'remembers folder when creates url' do
      click_on '/ru'
      click_on 'Create new page'
      fill_in 'Body', with: '# Some title'
      click_on 'Update Content'
      expect(page).to have_content("/ru/some-title")
    end

    it 'remembers folder event after content update' do
      click_on '/ru'
      click_on 'Create new page'
      fill_in 'Body', with: '# Some title'
      click_on 'Update Content'

      within '[data-content-panel]' do
        click_on 'Edit'
      end

      fill_in 'Body', with: '# Another title'
      click_on 'Update Content'

      expect(page).to have_content("/ru/another-title")
    end

    it 'creates a new page', driver: :webkit do
      click_on 'Create new page'

      # Edit page content
      select 'html', from: 'Markup language'
      fill_in 'Body', with: 'Body of newly created page'
      click_on 'Update Content'

      # Edit page url
      within '[data-url-panel]' do
        click_on 'Edit'
      end

      check 'page_override_url'
      fill_in 'page_url', with: '/created_page'
      click_on 'Update'

      # Edit page meta
      within '[data-meta-panel]' do
        click_on 'Edit'
      end
      check 'page_override_title'
      check 'page_override_name'
      check 'Override meta tags'
      fill_in 'Title', with: 'Created page'
      fill_in 'Name', with: 'Page name'
      fill_in 'Tags', with: 'RoR, Software Development'
      fill_in 'Authors', with: 'Kent Beck, DHH'
      fill_in_tag 'property', with: 'og:id', within_class: 'property_content'
      fill_in_tag 'content', with: '42', within_class: 'property_content'
      click_on 'Add open graph meta tag'
      fill_in_tag 'property', with: 'og:description', within_class: 'property_content'
      fill_in_tag 'content', with: 'site description', within_class: 'property_content'
      click_on 'Update Page'

      # Edit page annotation
      within '[data-annotation-panel]' do
        click_on 'Edit'
      end
      fill_in 'Body', with: 'Annotation of newly created page'
      click_on 'Update Content'

      expect(page).to have_content('Page "Page name"')

      new_page = Page.public_get '/created_page'
      expect(new_page).not_to be_nil
      expect(new_page.title).to eq('Created page')
      expect(new_page.name).to eq('Page name')
      expect(new_page.content.body).to eq('Body of newly created page')
      expect(new_page.content.markup_language).to eq('html')
      expect(new_page.annotation.body).to eq('Annotation of newly created page')
      expect(new_page.tags).to eq(['RoR', 'Software Development'])
      expect(new_page.authors).to eq(['Kent Beck', 'DHH'])

      expect(new_page.meta.count).to eq(3)
      expect(new_page.meta.first['property']).to eq('og:type')
      expect(new_page.meta.first['content']).to eq('website')
      expect(new_page.meta.second['property']).to eq('og:id')
      expect(new_page.meta.second['content']).to eq('42')
      expect(new_page.meta.last['property']).to eq('og:description')
      expect(new_page.meta.last['content']).to eq('site description')

      expect(current_path).to eq(cms.admin_page_path(new_page))
      expect(page).to have_content('Page name')
      expect(page).to have_content('Created page')
    end
  end

  context 'update page url', driver: :webkit do
    before do
      visit cms.admin_page_path(test_page)
      within '.url-panel' do
        click_on 'Edit'
      end
    end

    it 'edits a page' do
      check 'page_override_url'
      fill_in 'page_url', with: '/new_page_url'
      click_on 'Update'

      expect(current_path).to eq(cms.admin_page_path(test_page))
      expect(page).to have_content ('/new_page_url')
    end

    it 're-renders edit with validation errors' do
      check 'page_override_url'
      fill_in 'page_url', with: 'new page url'
      click_on 'Update'

      expect(current_path).to eq(cms.admin_page_path(test_page))
      expect(page).to have_content('is invalid')
    end

    it 'adds new url alias' do
      fill_in 'page_url_alias', with: '/this-is-page-alias'
      click_on 'Add'

      expect(current_path).to eq(cms.admin_page_path(test_page))
      expect(page).to have_content('/this-is-page-alias')
    end

    it 'changes page url and creates url alias' do
      check 'page_override_url'
      fill_in 'page_url', with: '/new_page_url'
      click_on 'Update'

      expect(page).to have_content ('/new_page_url')
      expect(page).to have_content ('Url aliases: /page_url')
    end

    context 'Url aliases manipulation' do
      let!(:url_alias) { create :url, name: '/this-is-page-alias', primary: false, page: test_page }

      before do
        visit cms.admin_page_path(test_page)
        within('.url-panel') { click_on 'Edit' }
      end

      it 'deletes url alias' do
        page.first('[data-delete-url-alias]').click
        expect(page).not_to have_content('/this-is-page-alias')
        expect(page).to have_content('/page_url')
        expect(Url.exists?(url_alias.id)).to be_falsy
      end

      it 'switches to new primary url' do
        find(:xpath, "//input[@value='#{url_alias.id}']").set(true)
        click_on 'Update'
        expect(page).to have_content ('/this-is-page-alias')
        expect(page).to have_content ('Url aliases: /page_url')
      end
    end
  end

  context 'update page content' do
    it 'edits a page' do
      visit cms.admin_page_path(test_page)
      within '.content-panel' do
        click_on 'Edit'
      end
      fill_in 'Body', with: 'new content body'
      click_on 'Update Content'

      expect(current_path).to eq(cms.admin_page_path(test_page))
      expect(page).to have_content ('new content body')
    end
  end

  context 'update page annotation' do
    before do
      visit cms.admin_page_path(test_page)
      within '.annotation-panel' do
        click_on 'Edit'
      end
    end

    def confirm_message
      JSON.parse(
        page.driver.instance_variable_get("@browser").command("JavascriptConfirmMessages")
      ).first
    end

    it 'edits a page' do
      fill_in 'Body', with: 'new annotation body'
      click_on 'Update Content'

      expect(current_path).to eq(cms.admin_page_path(test_page))
      expect(page).to have_content ('new annotation body')
    end

    it 'warns about too long annotation', driver: :webkit do
      fill_in 'Body', with: 'Annotation of newly created page' * 50
      click_on 'Update Content'
      expect(confirm_message).to eq("Body's maximum length should be less then 500.\nNow it is 1600.\nDo you still want to continue?")
    end
  end

  context 'update page meta info' do
    before do
      visit cms.admin_page_path(test_page)
    end

    it 'edits a page' do
      within '.meta-panel' do
        click_on 'Edit'
      end

      fill_in 'Title', with: 'Edited page'
      fill_in 'Name', with: 'Edited page name'
      click_on 'Update Page'

      expect(current_path).to eq(cms.admin_page_path(test_page))
      expect(page).to have_content('Title Edited page')
      expect(page).to have_content('Page "Edited page name"')
    end

    it 'takes props from content' do
      within '.content-panel' do
        click_on 'Edit'
      end

      fill_in 'Body', with: '# This is my title'
      click_on 'Update Content'

      expect(current_path).to eq(cms.admin_page_path(test_page))
      expect(page).to have_content('Title This is my title')
      expect(page).to have_content('Name This is my title')
      expect(page).to have_content('Breadcrumb This is my title')
    end

    it 'allows override page props' do
      within '.meta-panel' do
        click_on 'Edit'
      end

      check 'page_override_name'
      fill_in 'Name', with: 'This is my name'
      click_on 'Update Page'

      within '.content-panel' do
        click_on 'Edit'
      end

      fill_in 'Body', with: '# This is my title'
      click_on 'Update Content'

      expect(current_path).to eq(cms.admin_page_path(test_page))
      expect(page).to have_content('Title This is my title')
      expect(page).to have_content('Name This is my name')
    end

    it 'sets fields to readonly unless overrided', driver: :webkit do
      within '.meta-panel' do
        click_on 'Edit'
      end

      expect(find_field('Name')['readonly']).to be_present
      check 'page_override_name'
      expect(find_field('Name')['readonly']).not_to be_present
    end
  end

  context 'destroy' do
    it 'destroys page' do
      visit cms.admin_page_path(page_for_destroy)
      click_on 'Delete'
      expect(current_path).to eq(cms.delete_admin_page_path(page_for_destroy))

      expect(page).to have_content('Bad')

      click_on 'Destroy Page'

      expect(current_path).to eq(cms.admin_pages_path)
      expect(page).not_to have_content('Bad')
      expect(Page.where('urls.name' => '/bad_url').first).to be_deleted
    end

    it 'shows deleted pages on demand' do
      page_for_destroy.safe_delete
      visit cms.admin_pages_path
      click_on 'Show deleted'

      expect(page).to have_content('Bad')
    end

    it 'hides deleted pages on demand' do
      page_for_destroy.safe_delete
      visit cms.admin_pages_path
      click_on 'Show deleted'
      click_on 'Hide deleted'

      expect(page).not_to have_content('Bad')
    end
  end
end
