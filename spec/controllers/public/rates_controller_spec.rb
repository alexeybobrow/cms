require 'spec_helper'

RSpec.describe ::Cms::Public::RatesController, type: :controller do
  routes { Cms::Engine.routes }

  before do
    @page = create :page, :blog, :draft, url: '/blog/article', content_body: 'Article About Us'
    request.env["HTTP_REFERER"] = "where_i_came_from"
  end

  it 'create' do
    expect{ post :create, {page_id: @page.id, rate: 5} }.to change{Rate.count}.by(1)
    expect(response).to redirect_to "where_i_came_from"
  end
end
