require 'spec_helper'

describe 'public pages redirect' do
  let(:test_page) { create :page, url: '/home-page' }

  before do
    test_page.urls.create(name: '/home-page-alias', primary: false)
  end

  it 'redirects from url aliases to primary url' do
    visit '/home-page-alias'
    expect(current_path).to eq('/home-page')
  end

  it 'redirects url with not ascii symbols to 404' do
    visit '/en/%E2%80%8B'
    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end
