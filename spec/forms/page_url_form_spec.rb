require 'spec_helper'
require 'active_attr/rspec'

describe Cms::PageUrlForm do
  include Shoulda::Matchers::ActiveModel
  let(:form) { Cms::PageUrlForm.new({}, Page.new) }
  subject { form }

  it { is_expected.to have_attribute(:url).with_default_value_of('/') }

  context 'validation' do
    describe '#url' do
      it { is_expected.to allow_value('/ru/article_12').for(:url) }
      it { is_expected.to allow_value('/ru/blog/cool_stories/').for(:url) }
      it { is_expected.to allow_value('/en').for(:url) }
      it { is_expected.to allow_value('/blog/cool_stories/article').for(:url) }
      it { is_expected.to allow_value('/article_12').for(:url) }

      it { is_expected.not_to allow_value('/@#$%^&*').for(:url) }
      it { is_expected.not_to allow_value('/ page url').for(:url) }

      context 'validates uniqueness with case insensitivity' do
        before do
          create :page, url: '/ru/page_url'
        end

        it { is_expected.to_not allow_value('/ru/page_url').for(:url).ignoring_interference_by_writer }
        it { is_expected.to allow_value('/page_url').for(:url).ignoring_interference_by_writer }
        it { is_expected.to allow_value('/page_URL').for(:url).ignoring_interference_by_writer }
        it { is_expected.to_not allow_value('/ru/paGE_Url').for(:url).ignoring_interference_by_writer }
        it { is_expected.to_not allow_value('/RU/paGE_Url').for(:url).ignoring_interference_by_writer }
      end
    end

    describe '#clean_attributes' do
      it 'prepends / to url if missing' do
        form.url = 'about-us'
        form.clean_attributes
        expect(form.url).to eq('/about-us')
      end

      it 'does not prepend / to url if in place' do
        form.url = '/about-us'
        form.clean_attributes
        expect(form.url).to eq('/about-us')
      end
    end
  end
end
