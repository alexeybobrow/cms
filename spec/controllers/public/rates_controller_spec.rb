require 'spec_helper'

RSpec.describe ::Cms::Public::RatesController, type: :controller do
  routes { Cms::Engine.routes }

  let(:page) { create :page, :blog, :draft, url: '/blog/article', content_body: 'Article About Us' }

  before do
    request.env['HTTP_REFERER'] = 'where_i_came_from'
  end

  describe 'Success' do
    context 'html' do
      it 'create' do
        expect { post :create, page_id: page.id, rate: 5 }.to change { Rate.count }.by(1)
        expect(response).to redirect_to 'where_i_came_from'
      end
    end

    context 'json' do
      it 'create' do
        expect { post :create, page_id: page.id, rate: 5, format: :json }.to change { Rate.count }.by(1)
        expect(response.content_type).to eq('application/json')
        expect(JSON.parse(response.body)).to eq('rating' => 5.0, 'votes' => 1)
      end
    end
  end

  describe 'Fail' do
    context 'html' do
      it 'fails' do
        expect { post :create, page_id: page.id, rate: 0 }.not_to change { Rate.count }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'json' do
      it 'fails' do
        expect { post :create, page_id: page.id, rate: 0, format: :json }.not_to change { Rate.count }
        expect(response.content_type).to eq('application/json')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end
  end
end
