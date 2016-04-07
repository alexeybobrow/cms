# encoding: UTF-8

require 'spec_helper'

describe 'links for switching languages' do
  before :each do
    create :page,
      url: '/where-is-it'

    create :page,
      url: '/ru/where-is-it'

    create :page,
      url: '/only-en'
  end

  it 'contains translated page url if page exists in both languages' do
    visit '/where-is-it'

    within('footer .lang') do
      expect(page).to have_link('Russian', href: '/ru/where-is-it')
    end
  end

  it 'leads to localized homepage if page has no translation' do
    visit '/only-en'

    within('footer .lang') do
      expect(page).to have_link('Russian', href: '/ru')
    end
  end
end
