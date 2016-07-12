require 'spec_helper'
require 'active_attr/rspec'

describe Cms::PageUrlForm do
  include Shoulda::Matchers::ActiveModel
  let(:form) { Cms::PageUrlForm.new({}, Page.new) }
  subject { form }

  context 'validation' do
    describe 'url methods' do
      [:url, :url_alias].each do |field|
        it { is_expected.to allow_value('/ru/article_12').for(field) }
        it { is_expected.to allow_value('/ru/blog/cool_stories/').for(field).ignoring_interference_by_writer }
        it { is_expected.to allow_value('/en').for(field) }
        it { is_expected.to allow_value('/blog/cool_stories/article').for(field) }
        it { is_expected.to allow_value('/article_12').for(field) }

        it { is_expected.not_to allow_value('/@#$%^&*').for(field) }
        it { is_expected.not_to allow_value('/ page url').for(field) }
      end

      context 'validates uniqueness with case insensitivity' do
        before do
          create :page, url: '/ru/page_url'
        end

        [:url, :url_alias].each do |field|
          it { is_expected.to_not allow_value('/ru/page_url').for(field).ignoring_interference_by_writer }
          it { is_expected.to allow_value('/page_url').for(field).ignoring_interference_by_writer }
          it { is_expected.to allow_value('/page_URL').for(field).ignoring_interference_by_writer }
          it { is_expected.to_not allow_value('/ru/paGE_Url').for(field).ignoring_interference_by_writer }
          it { is_expected.to_not allow_value('/RU/paGE_Url').for(field).ignoring_interference_by_writer }
        end
      end
    end
  end

  describe '#url=' do
    it 'prepends / to url if missing' do
      form.url = 'about-us'
      expect(form.url).to eq('/about-us')
    end

    it 'does not prepend / to url if in place' do
      form.url = '/about-us'
      expect(form.url).to eq('/about-us')
    end
  end

  describe '#before_save' do
    it 'updates primary url' do
      form.url = '/new-primary'
      expect(Cms::UrlUpdate).to receive(:perform).once.with(form.model, '/new-primary')
      form.before_save
    end

    it 'switches primary url' do
      form.primary_id = 42
      expect(form.model).to receive(:switch_primary_url).with(42)
      form.before_save
    end
  end

  describe '#url' do
    it 'uses model#url as default value' do
      expect(form.model).to receive(:url).and_return('/about-us')
      expect(form.url).to eq('/about-us')
    end
  end
end

