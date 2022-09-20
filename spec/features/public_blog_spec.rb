require 'spec_helper'

describe 'public pages view', js: true do
  before :each do
    create :page, :blog,
      title: 'Searching for the truth',
      name: 'Searching for the truth',
      url: '/blog/where-is-it',
      annotation_body: 'Where is the white rabbit o_O.',
      content_body: 'Where is the white rabbit o_O. This text is under cut.'
  end

  describe 'blog#index' do
    before :each do
      visit '/blog'
    end

    it 'display short body' do
      expect(page).to have_content('Where is the white rabbit')
      expect(page).to have_no_content('This text is under cut')
    end

    it 'displays breadcrumbs' do
      expect(page).to have_content('Home > Blog')
    end
  end

  describe 'blog#show' do
    before :each do
      visit '/blog/where-is-it'
    end

    it 'display full body' do
      expect(page).to have_content('Where is the white rabbit')
      expect(page).to have_content('This text is under cut')
      expect(page).to have_title('Searching for the truth - Anadea')
    end

    it 'displays breadcrumbs' do
      expect(page).to have_content('Home > Blog > Searching for the truth')
    end
  end

  context 'Tags' do
    let!(:reactive_state) {
      create :page, :blog,
        url: '/blog/reactive-state-management',
        tags: ['Reactive', 'State management'],
        content_body: 'Article about reactive state management',
        annotation_body: 'Article about reactive state management'
    }

    let!(:reactive_db) {
      create :page, :blog,
      url: '/blog/reactive-database',
      tags: ['Reactive', 'Database'],
      content_body: 'Article about reactive database',
      annotation_body: 'Article about reactive database'
    }

    it 'displays tag link with articles count' do
      visit '/blog'
      expect(page).to have_content('Reactive 2')
      expect(page).to have_content('State management 1')
      expect(page).to have_content('Database 1')
    end

    it 'counts only published' do
      create :page, :blog, tags: ['reactive', 'state management'], workflow_state: :draft

      visit '/blog'
      expect(page).to have_content('Reactive 2')
      expect(page).to have_content('State management 1')
    end

    it 'filters articles by tag' do
      visit '/blog'
      within('aside') { click_on 'State management' }

      expect(page).to have_content('Article about reactive state management')
      expect(page).not_to have_content('Article about reactive database')
    end

    it 'uses proper url showing the results of filtering' do
      visit '/blog'
      within('aside') { click_on 'Reactive' }

      uri = URI.parse(current_url)
      expect(uri.path).to eq(cms.tag_blog_index_path(tag: 'reactive'))
    end

    it 'sorts tags alphabetically' do
      visit '/blog'

      expect(page).to have_content('Database 1 Reactive 2 State management 1')
    end
  end

  context 'Authors' do
    let!(:reactive_state) {
      create :page, :blog,
        url: '/blog/om',
        authors: ['David Nolen'],
        content_body: 'Article about om',
        annotation_body: 'Article about om'
    }

    let!(:reactive_db) {
      create :page, :blog,
      url: '/blog/clojure',
      authors: ['David Nolen', 'Rich Hickey'],
      content_body: 'Article about clojure',
      annotation_body: 'Article about clojure'
    }

    it 'filters articles over authors' do
      visit '/blog/author/rich-hickey'

      expect(page).to have_content('Article about clojure')
      expect(page).not_to have_content('Article about om')
    end
  end
end
