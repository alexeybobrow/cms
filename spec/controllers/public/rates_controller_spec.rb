require 'spec_helper'

RSpec.describe ::Cms::Public::RatesController, type: :controller do
  routes { Cms::Engine.routes }

  let(:page) { create :page, :blog, :draft, url: '/blog/article', content_body: 'Article About Us' }
  let(:session) { {} }

  before do
    request.env['HTTP_REFERER'] = 'where_i_came_from'
    allow_any_instance_of(described_class).to receive(:session).and_return(session)
  end

  describe 'Success' do
    it 'creates rate for html' do
      expect { post :create, page_id: page.id, rate: 5 }.to change { Rate.count }.by(1)
      expect(response).to redirect_to 'where_i_came_from'
      expect(session[:user_rated_posts]).to include(page.id.to_s)
    end

    it 'creates rate for json' do
      expect { post :create, page_id: page.id, rate: 5, format: :json }.to change { Rate.count }.by(1)
      expect(response.content_type).to eq('application/json')
      expect(JSON.parse(response.body)).to eq('rating' => 5.0, 'votes' => 1)
      expect(session[:user_rated_posts]).to include(page.id.to_s)
    end
  end

  describe 'Fail' do
    context 'user tries to rate with zero rate' do
      it 'fails in html' do
        expect { post :create, page_id: page.id, rate: 0 }.not_to change { Rate.count }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'fails in json' do
        expect { post :create, page_id: page.id, rate: 0, format: :json }.not_to change { Rate.count }
        expect(response.content_type).to eq('application/json')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end

    context 'user tries to rate the same page twice' do
      before do
        create :rate, page: page, value: 5.0
      end

      it 'successes but does not create a new rate' do
        params = { page_id: page.id, rate: 5, format: :json }
        session[:user_rated_posts] = [page.id.to_s]
        expect { post :create, params }.not_to change { Rate.count }
        expect(JSON.parse(response.body)).to eq('rating' => 5.0, 'votes' => 1)
        expect(session[:user_rated_posts].count).to eq 1
      end
    end
  end
end
