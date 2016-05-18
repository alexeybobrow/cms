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
end
