require 'spec_helper'

describe 'public pages view' do
  let(:text_with_code_block) {
    <<-SRC
```
puts "Hello world!"
```
SRC
  }
  let!(:new_word_page) {
    create :page,
      title: 'A new word in soft development',
      url: '/new-word',
      content_body: 'Follow the white rabbit...'
  }
  let!(:html_entity_in_title_page) {
    create :page,
      title: 'Stand up & fight!',
      url: '/html-entity-in-title',
      content_body: text_with_code_block
  }
  let!(:liquid_tag_in_title_page) {
    create :page,
      title: "RTFM! - {% link_to 'Manual', path: '/support' %}",
      url: '/liquid-tag-in-title-page',
      content_body: text_with_code_block
  }
  let!(:parent_page) {
    create :page,
      name: 'This is the new *hit',
      url: '/new',
      content_body: 'You take the blue pill, the story ends...'
  }
  let!(:nested_word_page) {
    create :page,
      title: 'You should pay for the unit tests',
      url: '/new/word',
      content_body: 'The matrix has you...'
  }
  let!(:root_page) {
    create :page,
      title: 'Software as it should be',
      url: '/',
      content_body: 'Welcome to the new world!'
  }
  let!(:page_with_code) {
    create :page,
      title: 'Cool article about programming',
      url: '/hello-world',
      content_body: text_with_code_block
  }

  let!(:html_page_with_code) {
    create :page, :html,
      title: 'Cool article about programming',
      url: '/hello-world-html',
      content_body: text_with_code_block
  }

  it 'displays page by url' do
    visit '/new-word'
    expect(page).to have_content('Follow the white rabbit...')
    expect(page).to have_title("A new word in soft development - Anadea")
  end

  it 'does not escape html entities in meta' do
    visit '/html-entity-in-title'
    expect(page).to have_title("Stand up & fight!")
  end

  it 'evaluate liquid tags in meta' do
    visit '/liquid-tag-in-title-page'
    expect(page).to have_title('RTFM! - <a href="/support">Manual</a>')
  end

  it 'displays 404 when page is missing' do
    visit '/not-exists'

    expect(page).to have_content("The page you were looking for doesn't exist")
  end

  it 'displays a root page on root' do
    visit '/'
    expect(page).to have_content('Welcome to the new world!')
  end

  it 'handles nested urls' do
    visit '/new/word'
    expect(page).to have_content('The matrix has you...')
  end

  it 'responds to html format' do
    visit '/new/word.html'
    expect(page).to have_content('The matrix has you...')
  end

  it 'renders page not found on non html format' do
    visit '/new/word.not_html'
    expect(page).to have_content("The page you were looking for doesn't exist")
  end

  it 'highlights the code' do
    visit '/hello-world'
    expect(page).to have_css(".highlight")
  end

  it 'does not do on html format' do
    visit '/hello-world-html'
    expect(page).not_to have_css("div.CodeRay")
  end

  it 'renders og data' do
    create :page, og: [{'name' =>'og:type', 'value' => 'site'}], url: '/og-test'
    visit '/og-test'
    expect(page).to have_css 'meta[property="og:type"]', :visible => false
  end

  context 'Edit link presence' do
    let!(:admin) { create :user, :admin }
    it 'page does not have \'Edit\' in footer if not signed in' do
      visit '/'
      within 'footer' do
        expect(page).not_to  have_link('Edit')
      end
    end
    it 'page has \'Edit\' in header if signed in' do
      sign_in admin
      visit '/'
      within 'header' do
        expect(page).to have_link('edit')
      end
    end
  end

  context 'Breadcrumbs' do
    it 'appends parent to the breadcrumbs set' do
      visit '/new/word'
      expect(page).to have_content('Home > This is the new *hit > You should pay for the unit tests')
    end
  end
end
