# encoding: UTF-8

require 'spec_helper'

RSpec::Matchers.define :contain_posts_in do |lang|
  match do |page|
    case lang
    when 'en'
      expect(page).to have_content('Where is the white rabbit')
      expect(page).to have_no_content('Где же белый кролик')
    when 'ru'
      expect(page).to have_content('Где же белый кролик')
      expect(page).to have_no_content('Where is the white rabbit')
    end
  end

  failure_message do |page|
    "expected that page would contain articles in #{lang}"
  end

  failure_message_when_negated do |page|
    "expected that page would not contain articles in #{lang}"
  end
end

describe 'internationalized blog view', driver: :webkit do
  before :each do
    create :page, :blog,
      title: 'Searching for the truth',
      url: '/blog/where-is-it',
      content_body: 'Where is the white rabbit o_O.',
      annotation_body: 'Where is the white rabbit o_O.'

    create :page, :blog,
      title: 'В поисках правды',
      url: '/ru/blog/where-is-it',
      content_body: 'Где же белый кролик o_O.',
      annotation_body: 'Где же белый кролик o_O.'
  end

  it 'displays content in english' do
    visit '/blog'
    expect(page).to contain_posts_in('en')
  end

  it 'displays content in russian' do
    visit '/ru/blog'
    expect(page).to contain_posts_in('ru')
  end

  describe 'language links' do
    it 'switches language to russian' do
      visit '/blog'
      page.first(:link, 'Russian').click

      expect(page).to contain_posts_in('ru')
    end

    it 'switches language to english' do
      visit '/ru/blog'
      page.first(:link, 'English').click

      expect(page).to contain_posts_in('en')
    end
  end
end
