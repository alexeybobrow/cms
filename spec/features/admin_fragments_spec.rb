# encoding: UTF-8

require 'spec_helper'

describe 'admin fragments management' do
  let!(:user) { create :user }

  before do
    sign_in user
  end

  context 'read' do
    before do
      create :fragment, slug: 'contact-us-footer'
      create :fragment, slug: 'contact-us-header'
    end

    it 'shows fragments list' do
      visit cms.admin_fragments_path
      expect(page).to have_content('contact-us-footer')
      expect(page).to have_content('contact-us-header')
    end
  end

  context 'create' do
    it 'creates new fragment', driver: :webkit do
      visit cms.admin_fragments_path
      click_on 'Create new fragment'

      fill_in 'Slug', with: 'contact-us-footer'
      fill_in 'Body', with: 'Copyright Anadea'
      select 'html', from: 'Markup language'

      click_on 'Create Fragment'

      expect(current_path).to eq(cms.admin_fragments_path)
      expect(page).to have_content('contact-us-footer')
    end
  end

  context 'update fragment' do
    let!(:fragment) { create :fragment, slug: 'contact-us-footer' }

    it 'edits fragment fields' do
      visit cms.admin_fragments_path
      click_on 'contact-us-footer'

      fill_in 'Body', with: 'Copyright Anadea'
      select 'html', from: 'Markup language'

      click_on 'Update Fragment'

      expect(current_path).to eq(cms.admin_fragments_path)
      expect(page).to have_content('contact-us-footer')
      expect(fragment.reload.content.body).to eq('Copyright Anadea')
      expect(fragment.content.markup_language).to eq('html')
    end
  end

  context 'destroy' do
    let!(:fragment) { create :fragment, slug: 'contact-us-footer' }

    it 'destroys fragment' do
      visit cms.admin_fragments_path

      page.first('[data-delete-fragment]').click
      expect(page).not_to have_content('contact-us-footer')
      expect(Fragment.exists?(fragment.id)).to be_falsy
    end
  end
end
