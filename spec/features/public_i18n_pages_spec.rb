# encoding: UTF-8

require 'spec_helper'

describe 'internationalized page view' do
  before :each do
    create :page,
      title: 'Searching for the truth',
      url: '/where-is-it',
      content_body: 'Where is the white rabbit o_O.',
      annotation_body: 'Where is the white rabbit o_O.'

    create :page,
      title: 'В поисках правды',
      url: '/ru/where-is-it',
      content_body: 'Где же белый кролик o_O.',
      annotation_body: 'Где же белый кролик o_O.'

    create :page,
      title: 'We dont speak americano',
      url: '/ru/ru-community'

    create :page,
      url: '/ru'
  end

  it 'can view page in english' do
    visit '/where-is-it'
    expect(page).to have_content('Where is the white rabbit')
  end

  it 'can view page in russian' do
    visit '/ru/where-is-it'
    expect(page).to have_content('Где же белый кролик')
  end

  context 'locale handler' do
    it 'redirects to root from locale url' do
      visit '/en'
      expect(current_path).to eq('/')
    end

    it 'redirects from default local' do
      visit '/en/where-is-it'
      expect(current_path).to eq('/where-is-it')
    end
  end
end
